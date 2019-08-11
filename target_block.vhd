library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;
-----------------------------------------------
------------- target_block VHDL ---------------
-----------------------------------------------
entity target_block is
    Port (
    clock : in std_logic;
    fetch  : in std_logic;
    target_in : in  STD_LOGIC_VECTOR(255 downto 0);  -- data from the fetch state
    target_out  : out  STD_LOGIC_VECTOR(255 downto 0)  -- send the target value to the Comperator unit for checking if we done
    );
end target_block; 
architecture rtl of target_block is
------------------------------- Signals -------------------------------------
type reg_arr is array(0 to 7) of STD_LOGIC_VECTOR(31 downto 0); -- 8 registers of 32 bit each, total: 256 bit
signal rData : reg_arr;
-----------------------------------------------------------------------------
begin
--------------------------------- rtl ---------------------------------------

process(clock) is
begin
  if rising_edge(clock) then
	if (fetch = '1') then
	     for counter in 1 to 8 loop		
	    	 rData(counter-1) <= target_in(((counter*32)-1) downto ((counter-1)*32));
	     end loop;
        end if;
  end if;
end process;	
end rtl;



