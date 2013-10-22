library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity synchro is
    port(   horl : in std_logic;
            adr_pixel : in integer range 0 to 797;
            adr_ligne : in integer range 0 to 525;
				sync_H : out std_logic;
				sync_V : out std_logic;
				video : out std_logic);
end synchro;

architecture A of synchro is
	begin
		process(horl)
			begin
			  if(horl'event and horl='1') then 
					if(adr_ligne<=1) then
						sync_V <= '0';
						else sync_V <= '1';
					end if;
					
					if(adr_pixel<=94) then
						sync_H <= '0';
						else sync_H <= '1';
					end if;
					
					if(adr_pixel>=141 and adr_ligne>=34 and adr_pixel<=781 and adr_ligne<=514) then
						video <= '1';
						else video <= '0';
					end if;
			  end if;
			end process;
end A;