library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity cptadpixel is
    port(   horl : in std_logic;
            adr_pixel : out integer range 0 to 797:=0;
            adr_ligne : out integer range 0 to 525:=0);
end cptadpixel;

architecture A of cptadpixel is
	signal adr_pixel_sig : integer range 0 to 797;
	signal adr_ligne_sig : integer range 0 to 525;
	
	begin
	adr_pixel <= adr_pixel_sig;
	adr_ligne <= adr_ligne_sig;
	
		process(horl)
		begin
        if(horl'event and horl='1') then 
            adr_pixel_sig<=adr_pixel_sig+1;
				if(adr_pixel_sig = 796) then
					adr_pixel_sig<=0;
					adr_ligne_sig<=adr_ligne_sig+1;
					if(adr_ligne_sig = 524) then
						adr_ligne_sig <= 0;
					end if;
				end if;
        end if;
		end process;
end A;