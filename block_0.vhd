library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;
-----------------------------------------------
---------- block_0 VHDL -----------------------
-----------------------------------------------
entity block_0 is
    Port (
    clock : in std_logic;
    fetch : in std_logic;
    header_value : in  STD_LOGIC_VECTOR(511 downto 0);  -- header value
    word_adrress : in  STD_LOGIC_VECTOR(3 downto 0);  -- line from SHA
    output  : out  STD_LOGIC_VECTOR(31 downto 0)); -- output of block_0 
end block_0; 
architecture rtl of block_0 is
------------------------------- Signals -------------------------------------
type reg_arr is array(0 to 15) of STD_LOGIC_VECTOR(31 downto 0); -- 16 registers of 32 bit each
signal rData : reg_arr;
-----------------------------------------------------------------------------
begin
--------------------------------- rtl ---------------------------------------
-- Gets the current adrees from the SHA
output <= rData(to_integer(unsigned(word_adrress))); 

process(clock) is
begin
  if rising_edge(clock) then
	if (fetch = '1') then
	     for counter in 1 to 16 loop		
	    	 rData(counter-1) <= header_value(((counter*32)-1) downto ((counter-1)*32));
	     end loop;
        end if;
  end if;
end process;	
end rtl;
