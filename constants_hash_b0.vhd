library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;
-----------------------------------------------
---------- constants_hash_b0 VHDL -------------
-----------------------------------------------
entity constants_hash_b0 is
    Port (
    clock : in std_logic;
    save_constants  : in std_logic;
    sha_output : in  STD_LOGIC_VECTOR(255 downto 0);  -- SHA output
    -- sends the old constants for the next iteration --
    h0_before : out std_logic_vector(31 downto 0);
    h1_before: out std_logic_vector(31 downto 0);
    h2_before: out std_logic_vector(31 downto 0);
    h3_before: out std_logic_vector(31 downto 0);
    h4_before: out std_logic_vector(31 downto 0);
    h5_before: out std_logic_vector(31 downto 0);
    h6_before: out std_logic_vector(31 downto 0);
    h7_before: out std_logic_vector(31 downto 0)  
    );
end constants_hash_b0; 
architecture rtl of constants_hash_b0 is
------------------------------- Signals -------------------------------------
type reg_arr is array(0 to 7) of STD_LOGIC_VECTOR(31 downto 0); -- 8 registers of 32 bit each
signal rData : reg_arr;
-----------------------------------------------------------------------------
begin
--------------------------------- rtl ---------------------------------------
	h0_before <= rData(0);
	h1_before <= rData(1);
	h2_before <= rData(2);
	h3_before <= rData(3);
	h4_before <= rData(4);
	h5_before <= rData(5);
	h6_before <= rData(6);
	h7_before <= rData(7);
process(clock) is
begin
  if rising_edge(clock) then
	if (save_constants = '1') then
	     for counter in 1 to 8 loop		
	    	 rData(counter-1) <= sha_output(((counter*32)-1) downto ((counter-1)*32));
	     end loop;
        end if;
  end if;
end process;	
end rtl;



