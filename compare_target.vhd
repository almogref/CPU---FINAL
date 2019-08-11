library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;
-----------------------------------------------
------------ compare_target VHDL --------------
-----------------------------------------------
entity compare_target is
    Port (
    clock  : in std_logic; 
    ready  : in std_logic; -- SHA is done 
    target : in  STD_LOGIC_VECTOR(255 downto 0);  -- target value
    hash_output : in  STD_LOGIC_VECTOR(255 downto 0);  -- SHL output value 
    hash_output_register : out  STD_LOGIC_VECTOR(255 downto 0); 
    success  : out  std_logic  -- 1/0 equals T/F
    );
end compare_target; 
architecture rtl of compare_target is 
type hash_output_buffer is array(0 to 31) of STD_LOGIC_VECTOR(7 downto 0); -- 32 registers of 8 bit each
type hash_output_little is array(0 to 31) of STD_LOGIC_VECTOR(7 downto 0); -- 32 registers of 8 bit each
signal rData_b : hash_output_buffer;
signal rData_l : hash_output_little;
signal hash_little : STD_LOGIC_VECTOR(255 downto 0);
begin
--------------------------------- rtl ---------------------------------------

process(clock) is
begin
  if rising_edge(clock) then
	if (ready = '1') then
		hash_output_register <= hash_output;
        end if;
  end if;
end process;	

process(clock) is 
begin
	for i in 1 to 32 loop
		 rData_b(i-1)   <=  hash_output(((i*8)-1) downto ((i-1)*8));		
		 rData_l(i-1)   <=  rData_b(32-i);
	end loop;
end process;	



hash_little <= 	(rData_l(31)&rData_l(30)&rData_l(29)&
	         rData_l(28)&rData_l(27)&rData_l(26)&
		 rData_l(25)&rData_l(24)&rData_l(23)& 
	         rData_l(22)&rData_l(21)&rData_l(20)&
		 rData_l(19)&rData_l(18)&rData_l(17)&
		 rData_l(16)&rData_l(15)&rData_l(14)&
		 rData_l(13)&rData_l(12)&rData_l(11)&
		 rData_l(10)&rData_l(9)&rData_l(8)& 
		 rData_l(7)&rData_l(6)&rData_l(5)&
	         rData_l(4)&rData_l(3)&rData_l(2)&
		 rData_l(1)&rData_l(0));

success <= '1' when  target > hash_little  else '0';

end rtl;




