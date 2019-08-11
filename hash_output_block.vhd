library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;
-----------------------------------------------
---------- hash_output_block VHDL -------------
-----------------------------------------------
entity hash_output_block is
    Port (
    clock : in std_logic;
    get_hash  : in std_logic;
    word_adrress : in  STD_LOGIC_VECTOR(3 downto 0);  -- line from SHA
    sha_output : in  STD_LOGIC_VECTOR(255 downto 0);  -- SHA output
    output  : out  STD_LOGIC_VECTOR(31 downto 0) 
    );
end hash_output_block; 
architecture rtl of hash_output_block is
------------------------------- Signals -------------------------------------
type reg_arr is array(0 to 15) of STD_LOGIC_VECTOR(31 downto 0); -- 16 registers of 32 bit each
signal rData : reg_arr;
signal hash_padded : STD_LOGIC_VECTOR(511 downto 0);
constant PADDED_8 : std_logic_vector(3 downto 0) := x"8";
constant PADDED_0 : std_logic_vector(239 downto 0) := x"000000000000000000000000000000000000000000000000000000000000";
constant PADDED_100 : std_logic_vector(11 downto 0) := x"100"; 
-----------------------------------------------------------------------------
begin
--------------------------------- rtl ---------------------------------------

-- Gets the current adrees from the SHA
output <= rData(to_integer(unsigned(word_adrress))); 

process(clock) is
begin
  if rising_edge(clock) then
	if (get_hash = '1') then
		hash_padded <= sha_output&PADDED_8&PADDED_0&PADDED_100; 
	     for counter in 1 to 16 loop		
	    	 rData(counter-1) <= hash_padded(((counter*32)-1) downto ((counter-1)*32));
	     end loop;
        end if;
  end if;
end process;	
end rtl;



