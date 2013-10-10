library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity async_serial_receiver is
end async_serial_receiver;

architecture behaviour of async_serial_receiver is
  
  type states is (
    listening,
    rwb0,
    rwb1,
    rwb2,
    rwb3,
    rsb0,
    rsb1
  );

  signal state                : states := listening;
  signal clk, reset, dr       : std_logic := '0';
  signal din                  : std_logic := '1';
  signal dout                 : std_logic_vector(3 downto 0) := "0000";

begin
  
  clk <= not clk after 10ns;
  
  -- Start bit
  din <= '0' after 35 ns,
         '1' after 45 ns,
         '0' after 55 ns,
         '0' after 65 ns,
         '1' after 75 ns,
         '1' after 85 ns,
         '1' after 95 ns;

  process (clk)
  begin
    case state is
    when listening =>
      if dr = '1' then
        dr <= '0';
      end if;
      if din = '0' then
        state <= rwb0;
      end if;
    when rwb0 =>
      dout(0) <= din;
      state <= rwb1;
    when rwb1 =>
      dout(1) <= din;
      state <= rwb2;
    when rwb2 =>
      dout(2) <= din;
      state <= rwb3;
    when rwb3 =>
      dout(3) <= din;
      state <= rsb0;
    when rsb0 =>
      if din = '1' then
        state <= rsb1;
      else
        state <= listening;
      end if;
    when rsb1 =>
      if din = '1' then
        dr <= '1';
      end if;
      state <= listening;
    end case;
  end process;

end behaviour;