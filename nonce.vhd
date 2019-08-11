library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;
-----------------------------------------------
---------------- nonce VHDL -------------------
-----------------------------------------------
entity nonce is
    Port (
    clock : in std_logic;
    reset : in std_logic;
    update_nonce  : in std_logic;
    nonce : in  STD_LOGIC_VECTOR(31 downto 0); 
    updated_nonce  : out  STD_LOGIC_VECTOR(31 downto 0)  -- sends nonce+1 to b1
    );
end nonce; 
architecture rtl of nonce is
------------------------------- Signals -------------------------------------
signal q : STD_LOGIC_VECTOR(31 downto 0):= X"00000000";
signal p : STD_LOGIC_VECTOR(31 downto 0):= X"00000000";
-----------------------------------------------------------------------------
begin
--------------------------------- rtl ---------------------------------------

updated_nonce <= q;

process(clock) is
begin
  if rising_edge(clock) then
	if (reset = '1') then
	     p  <= nonce + 1;   
	elsif (update_nonce = '1') then
	     q <= p;
	     p <= p + 1;
        end if;
  end if;
end process;	
end rtl;




