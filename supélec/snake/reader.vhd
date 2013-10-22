library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;

entity reader is
    port(   horl : in std_logic;
            adr_pixel : in integer range 0 to 1023;
            adr_ligne : in integer range 0 to 1023;
				level : in integer range 0 to 3;
				adrmem : out integer range 0 to 19199
				);
end reader;

architecture A of reader is
	begin
		process(horl)
		variable output_adr_pixel : integer range 0 to 1023;
		variable output_adr_ligne : integer range 0 to 1023;
			begin
			  if(horl'event and horl='1') then 				
					output_adr_ligne := adr_ligne-34;
					output_adr_pixel := adr_pixel-141;
					case level is
						when 0 =>
							output_adr_ligne := output_adr_ligne/32;
							output_adr_pixel := output_adr_pixel/32;
							adrmem <= output_adr_pixel + output_adr_ligne * 20;
						when 1 =>
							output_adr_ligne := output_adr_ligne/16;
							output_adr_pixel := output_adr_pixel/16;
							adrmem <= output_adr_pixel + output_adr_ligne * 40;
						when 2 =>
							output_adr_ligne := output_adr_ligne/8;
							output_adr_pixel := output_adr_pixel/8;
							adrmem <= output_adr_pixel + output_adr_ligne * 80;
						when 3 =>
							output_adr_ligne := output_adr_ligne/4;
							output_adr_pixel := output_adr_pixel/4;
							adrmem <= output_adr_pixel + output_adr_ligne * 160;
					end case;
			  end if;
			end process;
end A;