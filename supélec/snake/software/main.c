#include <stdio.h>
#include "io.h"
#include <system.h>
#include "alt_types.h"
#include <math.h>
#include "alt_types.h"
#include "altera_avalon_pio_regs.h"
#include "altera_avalon_timer_regs.h"
#include "altera_avalon_timer.h"
#include "altera_nios2_qsys_irq.h"
#include "sys/alt_irq.h"
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>
#include <sys/alt_timestamp.h>


#define SCREEN_WIDTH 640
#define SCREEN_HEIGHT 480
#define SPEED_INCREASE_FACTOR 1.15

#define MEM_WIDTH 160
#define MEM_HEIGHT 120

typedef struct {
	int line;
	int column;
} point;

typedef enum { up, right, down, left } direction;
typedef enum { linked_up = 4, linked_right, linked_down, linked_left } link_relation;
typedef enum { welcome, select_size, select_walls, ready, play, score } game_state;

int systick;
int snake_total_period_ms;
int snake_current_ms;
int matrix_width;
int matrix_height;
int size_selector;
int walls_selector;
unsigned points;
volatile direction dir;
volatile point head;
volatile point tail;
volatile int edge_capture;
volatile game_state state;
volatile int button_pressed;
volatile int last_button_pressed;


void handle_button_interrupts(void *);
static void init_button_pio(void);
int read_pixel(point);
void write_pixel(point, int);
void print_one_wall(point, point, int);
void print_walls(int type);
void initialize_snake(point, point);
void set_food(void);
void disable_timer_interrupt(void);
void enable_timer_interrupt(void);
void clean_game_screen(int);
void increase_speed(void);
void update_snake(void);
static void handle_timer_interrupts(void *);
void init_timer_interrupt(void);

void handle_button_interrupts(void *context)
{
    /* Cast context to edge_capture's type. It is important that this be
     * declared volatile to avoid unwanted compiler optimization.
     */
    volatile int * edge_capture_ptr = (volatile int *) context;
    /* Store the value in the Button's edge capture register in *context. */
    *edge_capture_ptr = IORD_ALTERA_AVALON_PIO_EDGE_CAP(INPUT8BITS_BASE);
    /* Reset the Button's edge capture register. */
    IOWR_ALTERA_AVALON_PIO_EDGE_CAP(INPUT8BITS_BASE, 0);

    /*
     * Read the PIO to delay ISR exit. This is done to prevent a spurious
     * interrupt in systems with high processor -> pio latency and fast
     * interrupts.
     */
    IORD_ALTERA_AVALON_PIO_EDGE_CAP(INPUT8BITS_BASE);

    switch (edge_capture) {
		case 0x1:
			button_pressed = 1;
			edge_capture = 0;
			break;
		case 0x2:
			button_pressed = 2;
			edge_capture = 0;
			break;
		case 0x4:
			button_pressed = 3;
			edge_capture = 0;
			break;
		case 0x8:
			button_pressed = 4;
			edge_capture = 0;
			break;
		default:
			button_pressed = 0;
			edge_capture = 0;
			break;
	}

    if (button_pressed) {
		switch (state) {
			case welcome:
				srand(systick);
				clean_game_screen(0);
				state = select_size;
				printf("Starting game...\n\nSelect size!\n");
				break;
			case select_size:
				size_selector = button_pressed - 1;
				if (last_button_pressed == button_pressed) {
					state = select_walls;
					last_button_pressed = 0;
					printf("Size selected: %d\n\nSelect walls!\n", size_selector);
					break;
				}
				last_button_pressed = button_pressed;

				IOWR(OUTPUT_LEVEL_BASE, 0, size_selector);

				switch (size_selector) {
					case 0:
						matrix_width = 20;
						matrix_height = 15;
						break;
					case 1:
						matrix_width = 40;
						matrix_height = 30;
						break;
					case 2:
						matrix_width = 80;
						matrix_height = 60;
						break;
					case 3:
						matrix_width = 160;
						matrix_height = 120;
						break;
					default :
						matrix_width = 20;
						matrix_height = 15;
						break;
				}

				snake_total_period_ms = 700 / exp2(size_selector);

				dir = left;
				head.line = (int) (0.5*matrix_height);
				head.column = (int) (0.25*matrix_height);
				tail.line = (int) (0.5*matrix_height);
				tail.column = (int) (0.75*matrix_height);

				clean_game_screen(0);

				initialize_snake(head, tail);
				break;
			case select_walls:
				walls_selector = button_pressed - 1;
				if (last_button_pressed == button_pressed) {
					last_button_pressed = 0;
					state = ready;
					set_food();
					printf("Walls selected: %d\n\n", walls_selector);
					printf("Ready?\n\n");
					break;
				}
				last_button_pressed = button_pressed;

				clean_game_screen(0);
				initialize_snake(head, tail);
				print_walls(walls_selector);
				break;
			case ready:
				state = play;
				printf("Play!\n\n");
				break;
			case play:
				last_button_pressed = button_pressed;
				break;
			case score:
				clean_game_screen(1);
				state = welcome;
				printf("Welcome!\n\n");
				break;
			default:
				break;
		}
    }
}

static void init_button_pio(void)
{
    /* Recast the edge_capture pointer to match the alt_irq_register() function
     * prototype. */
    void * edge_capture_ptr = (void *) &edge_capture;
    /* Enable all 4 button interrupts. */
    IOWR_ALTERA_AVALON_PIO_IRQ_MASK(INPUT8BITS_BASE, 0xf);
    /* Reset the edge capture register. */
    IOWR_ALTERA_AVALON_PIO_EDGE_CAP(INPUT8BITS_BASE, 0x0);
    /* Register the interrupt handler. */
    alt_ic_isr_register(INPUT8BITS_IRQ_INTERRUPT_CONTROLLER_ID, INPUT8BITS_IRQ,
      handle_button_interrupts, edge_capture_ptr, 0x0);
}

int read_pixel(point p)
{
	IOWR(OUTPUT_MEM_WREN_BASE, 0, 0);
	IOWR(OUTPUT_MEM_ADR_BASE, 0, p.line * matrix_width + p.column);
	return IORD(INPUT_MEM_DATA_BASE, 0);
}

void write_pixel(point p, int value)
{
	IOWR(OUTPUT_MEM_WREN_BASE, 0, 0);
	IOWR(OUTPUT_MEM_DATA_BASE, 0, value);
	IOWR(OUTPUT_MEM_ADR_BASE, 0, p.line * matrix_width + p.column);
	IOWR(OUTPUT_MEM_WREN_BASE, 0, 1);
	IOWR(OUTPUT_MEM_WREN_BASE, 0, 0);
}

void print_one_wall(point head, point tail, int col_first)
{
	if (!read_pixel(head)) write_pixel(head, 2);
	if (col_first) {
		while (head.line - tail.line) {
			if (head.line - tail.line > 0) head.line--;
			else head.line++;
			if (!read_pixel(head)) write_pixel(head, 2);
		}
		while (head.column - tail.column) {
			if (head.column - tail.column > 0) head.column--;
			else head.column++;
			if (!read_pixel(head)) write_pixel(head, 2);
		}
	} else {
		while (head.column - tail.column) {
			if (head.column - tail.column > 0) head.column--;
			else head.column++;
			if (!read_pixel(head)) write_pixel(head, 2);
		}
		while (head.line - tail.line) {
			if (head.line - tail.line > 0) head.line--;
			else head.line++;
			if (!read_pixel(head)) write_pixel(head, 2);
		}
	}
}

void print_walls(int type)
{
	point start, end;
	switch (type) {
		case 0:		// No walls
			break;
		case 1:		//Walls on borders
			start.line = 0;
			start.column = 0;
			end.line = matrix_height - 1;
			end.column = matrix_width - 1;
			print_one_wall(start, end, 1);
			print_one_wall(start, end, 0);
			break;
		case 2:		//Holed walls on borders
			start.line = (int) (0.4*matrix_height);
			start.column = 0;
			end.line = 0;
			end.column = (int) (0.4*matrix_width);
			print_one_wall(start, end, 1);

			start.line = (int) (0.6*matrix_height);
			start.column = 0;
			end.line = matrix_height-1;
			end.column = (int) ((0.4)*matrix_width);
			print_one_wall(start, end, 1);

			start.line = 0;
			start.column = (int) (0.6*matrix_width);
			end.line = (int) (0.4*matrix_height);
			end.column = matrix_width-1;
			print_one_wall(start, end, 0);

			start.line = matrix_height-1;
			start.column = (int) (0.6*matrix_width);
			end.line = (int) (0.6*matrix_height);
			end.column = matrix_width-1;
			print_one_wall(start, end, 0);
			break;
		case 3:		//Holed walls on borders, smiley
			//Printing borders
			start.line = (int) (0.4*matrix_height);
			start.column = 0;
			end.line = 0;
			end.column = (int) (0.4*matrix_width);
			print_one_wall(start, end, 1);

			start.line = (int) (0.6*matrix_height);
			start.column = 0;
			end.line = matrix_height-1;
			end.column = (int) ((0.4)*matrix_width);
			print_one_wall(start, end, 1);

			start.line = 0;
			start.column = (int) (0.6*matrix_width);
			end.line = (int) (0.4*matrix_height);
			end.column = matrix_width-1;
			print_one_wall(start, end, 0);

			start.line = matrix_height-1;
			start.column = (int) (0.6*matrix_width);
			end.line = (int) (0.6*matrix_height);
			end.column = matrix_width-1;
			print_one_wall(start, end, 0);

			//Printing central pattern
			start.line = (int) (0.5*matrix_height + 1);
			start.column = (int) (0.3*matrix_width);
			end.line = (int) (0.65*matrix_height);
			end.column = start.column;
			print_one_wall(start, end, 0);

			start = end;
			end.line = (int) (0.5*matrix_height + 1);
			end.column = (int) (0.7*matrix_width);
			print_one_wall(start, end, 0);

			start.line = (int) (0.3*matrix_height);
			start.column = (int) (0.4*matrix_width);
			end.line = (int) (0.5*matrix_height-1);
			end.column = start.column;
			print_one_wall(start, end, 0);

			start.column = (int) (0.6*matrix_width);
			end.column = start.column;
			print_one_wall(start, end, 0);
			break;
		default :
			break;
	}
}

void initialize_snake(point head, point tail)
{
	link_relation linked_to;

	// Write head
	write_pixel(head, 1);

	// Write body
	while (head.line - tail.line) {
		if (head.line - tail.line > 0) {
			head.line--;
			linked_to = linked_down;
		} else {
			head.line++;
			linked_to = linked_up;
		}
		write_pixel(head, linked_to);
	}
	while (head.column - tail.column) {
		if (head.column - tail.column > 0) {
			head.column--;
			linked_to = linked_right;
		} else {
			head.column++;
			linked_to = linked_left;
		}
		write_pixel(head, linked_to);
	}
}

void set_food(void)
{
	point food_pos;
	do {
		food_pos.line = rand() % matrix_height;
		food_pos.column = rand() % matrix_width;
	} while (read_pixel(food_pos));
	write_pixel(food_pos, 3);
}

void disable_timer_interrupt(void)
{
    IOWR_ALTERA_AVALON_TIMER_CONTROL(TIMER_1_BASE,(0 << 2) | (0 << 1) | (0 << 0) ); //Start Timer, IRQ enable, Continuous enable
}

void enable_timer_interrupt(void)
{
    IOWR_ALTERA_AVALON_TIMER_CONTROL(TIMER_1_BASE,(1 << 2) | (1 << 1) | (1 << 0) ); //Start Timer, IRQ enable, Continuous enable
}

void clean_game_screen(int value)
{
	int i;
	IOWR(OUTPUT_MEM_DATA_BASE, 0, value);
	IOWR(OUTPUT_MEM_WREN_BASE, 0, 1);
	for (i = 0; i < 19200; i++) IOWR(OUTPUT_MEM_ADR_BASE, 0, i);
	IOWR(OUTPUT_MEM_WREN_BASE, 0, 0);
}

void increase_speed(void)
{
	snake_total_period_ms = snake_total_period_ms / SPEED_INCREASE_FACTOR;
}

void update_snake(void)
{
	int destination_value;
	link_relation linked_to;

	switch (last_button_pressed) {
		case 1:
			if (dir == left || dir == right) dir = up;
			break;
		case 2:
			if (dir == up || dir == down) dir = right;
			break;
		case 3:
			if (dir == left || dir == right) dir = down;
			break;
		case 4:
			if (dir == up || dir == down) dir = left;
			break;
		default:
			break;
	}

	// Update neck
	switch (dir) {
		case up:
			linked_to = linked_up;
			break;
		case right:
			linked_to = linked_right;
			break;
		case down:
			linked_to = linked_down;
			break;
		case left:
			linked_to = linked_left;
			break;
		default:
			break;
	}
	write_pixel(head, linked_to);

	// Update head
	switch (dir) {
		case up:
			head.line--;
			if (head.line < 0) head.line = matrix_height - 1;
			break;
		case right:
			head.column++;
			if (head.column > matrix_width - 1) head.column = 0;
			break;
		case down:
			head.line++;
			if (head.line > matrix_height - 1) head.line = 0;
			break;
		case left:
			head.column--;
			if (head.column < 0) head.column = matrix_width - 1;
			break;
		default:
			break;
	}
	destination_value = read_pixel(head);
	if (destination_value > 3 || destination_value == 2) {
		state = score;
		clean_game_screen(2);
		printf("\n\n\n\n\n\n\n\n\nScore: %d\n\n", points);
		points = 0;
		return;
	}
	write_pixel(head, 1);

	// Update tail
	if (destination_value != 3) {
		linked_to = read_pixel(tail);
		write_pixel(tail, 0);
		switch (linked_to) {
			case linked_up:
				tail.line--;
				if (tail.line < 0) tail.line = matrix_height - 1;
				break;
			case linked_right:
				tail.column++;
				if (tail.column > matrix_width - 1) tail.column = 0;
				break;
			case linked_down:
				tail.line++;
				if (tail.line > matrix_height - 1) tail.line = 0;
				break;
			case linked_left:
				tail.column--;
				if (tail.column < 0) tail.column = matrix_width - 1;
				break;
			default:
				break;
		}
	} else {
		set_food();
		increase_speed();
		points += 1000;
	}
}

static void handle_timer_interrupts(void *context)
{
	systick++;

	if (state == play && !(snake_current_ms++ < snake_total_period_ms)) {
		printf("\n\n\n\n\n\n\n\n\n%d", points);
		update_snake();
		snake_current_ms = 0;
		if (points) points--;
	}

	IOWR_ALTERA_AVALON_TIMER_STATUS(TIMER_1_BASE, 0); // Clear TO(timeout) bit
}

void init_timer_interrupt(void)
{
    systick = 0;
    snake_current_ms = 0;
    void* ptr;
    IOWR_ALTERA_AVALON_TIMER_STATUS(TIMER_1_BASE, 0); // Clear TO Bit
    IOWR_ALTERA_AVALON_TIMER_CONTROL(TIMER_1_BASE, (1<<2) | (1 << 1) | (1 << 0)); // Start Timer, IRQ enable, Continuous enable
    alt_ic_isr_register(TIMER_1_IRQ_INTERRUPT_CONTROLLER_ID, TIMER_1_IRQ, handle_timer_interrupts, ptr, 0x0); // Register Interrupt
}

int main(void)
{
	button_pressed = 0;
	last_button_pressed = 0;
	points = 0;
	state = welcome;

	init_button_pio();
	init_timer_interrupt();

	clean_game_screen(1);
	printf("Welcome!\n\n");

	while (1);

	return 0;
}
