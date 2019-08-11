library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.ALL;
-----------------------------------------------
---------- FSM - VHDL -------------------------
-----------------------------------------------
ENTITY statem is
PORT (clock:    IN STD_LOGIC;
      reset:    IN STD_LOGIC;
      start : IN STD_LOGIC;
      success : IN STD_LOGIC;
      ready : IN STD_LOGIC;
      get_hash : OUT STD_LOGIC;
      update_nonce : OUT STD_LOGIC;
      reset_nonce : OUT STD_LOGIC; 	
      fetch  : OUT STD_LOGIC;
      block_sel  : OUT STD_LOGIC_VECTOR(1 downto 0);
      update_SHA : OUT STD_LOGIC;
      update_constants : OUT STD_LOGIC;
      reset_SHA : OUT STD_LOGIC;
      sha_enable : OUT STD_LOGIC;
      save_constants : OUT STD_LOGIC;
      -- ####### FOR TESTING PURPOSES ####### --
      STATE_TEST : OUT STD_LOGIC_VECTOR(7 downto 0);
      -- ####### FOR TESTING PURPOSES ####### --
      hash_ready : OUT STD_LOGIC);
END statem;


Architecture rtl of statem is
TYPE State_type IS (Idle, Fetching, B_0_begin, B_0_progress_a,B_0_progress_b, B_0_hash, B_1_begin, B_1_progress_a, B_1_progress_b, Hash_1,
	SHA_reset, Second_hash, Second_hash_progress_a, Second_hash_progress_b , Increase_Nonce);  
SIGNAL State : State_Type;    -- Create a signal that uses the different states						     
SIGNAL counter : integer :=0;

BEGIN 
  PROCESS (clock, reset) 
  BEGIN 
    	IF rising_edge(clock) THEN 
	 	IF (reset = '1') THEN
		        -- Reset values            
			State <= Idle;
		        sha_enable <= '1';
			hash_ready <= '1';
			fetch <= '0';
			reset_nonce <= '0';
			get_hash <= '0';
			update_nonce <= '0';
			block_sel <= "00";
			update_SHA <= '0';
			update_constants <= '0';
			reset_SHA <= '1';
			save_constants <= '0';
			counter <= 0; 
			-- #### TEST #### --
			STATE_TEST <= X"00";
			--################--
		ELSE  
			-- Default values
			sha_enable <= '1';
			hash_ready <= '0';
			fetch <= '0';
			reset_nonce <= '0';
			get_hash <= '0';
			update_nonce <= '0';
			block_sel <= "00";
			update_SHA <= '0';
			update_constants <= '0';
			reset_SHA <= '0';
			save_constants <= '0';
			CASE State IS
			-----------------------------------------------------------
			----------------------- State: Idle -----------------------
			-----------------------------------------------------------
				WHEN Idle =>
					-- #### TEST #### --
					STATE_TEST <= X"00";
					--################--
					hash_ready <= '1';
					IF start = '1' THEN 
						State <= Fetching;
					END IF; 
 			-----------------------------------------------------------
			----------------------- State: fetch ----------------------
			-----------------------------------------------------------
				WHEN Fetching => 
					-- #### TEST #### --
					STATE_TEST <= X"01";
					--################--
					State <= B_0_begin;
					reset_nonce <= '1';  
					fetch <= '1';

--				WHEN Fetching => 
--					-- #### TEST #### --
--					STATE_TEST <= X"1";
--					--################--
--					counter <= counter + 1;	
--					IF ((counter = 0) AND (start='1')) THEN 
--						State <= Fetching;
--						reset_nonce <= '1';  
--						fetch <= '1';
--  					ELSIF ((counter = 1) AND (start='1')) THEN 
--			   			State <= B_0_begin;		 
--					END IF; 
			-----------------------------------------------------------
			----------------------- State: B_0_begin ------------------
			-----------------------------------------------------------
				WHEN B_0_begin => 
					-- #### TEST #### --
					STATE_TEST <= X"02";
					--################--
					State <= B_0_progress_a;
					update_SHA <= '1';

			-----------------------------------------------------------
			-------------------- State: B_0_progress_a ----------------
			-----------------------------------------------------------
				WHEN B_0_progress_a =>
					-- #### TEST #### --
					STATE_TEST <= X"03";
					State <= B_0_progress_b;
					--################--
			-----------------------------------------------------------
			-------------------- State: B_0_progress_b ----------------
			-----------------------------------------------------------
				WHEN B_0_progress_b =>
					-- #### TEST #### --
					STATE_TEST <= X"04";
					--################--
					IF ready ='1' THEN  
						State <= B_0_hash;
					END IF; 
			-----------------------------------------------------------
			-------------------- State: B_0_hash ----------------------
			-----------------------------------------------------------
				WHEN B_0_hash => 
					-- #### TEST #### --
					STATE_TEST <= X"05";
					--################--
					State <= B_1_begin;
					save_constants <= '1';
			-----------------------------------------------------------
			----------------------- State: B_1_begin ------------------
			-----------------------------------------------------------
				WHEN B_1_begin => 
					-- #### TEST #### --
					STATE_TEST <= X"06";
					--################--
					State <= B_1_progress_a;
					block_sel <= "01";
					update_SHA <= '1';
					update_constants <= '1';

			-----------------------------------------------------------
			-------------------- State: B_1_progress_a ----------------
			-----------------------------------------------------------
				WHEN B_1_progress_a =>
					-- #### TEST #### --
					STATE_TEST <= X"07";
					--################--
					block_sel <= "01";

					State <= B_1_progress_b;
 
			-------------------------------------

			-----------------------------------------------------------
			------------------- State: B_1_progress_b -----------------
			-----------------------------------------------------------
				WHEN B_1_progress_b =>
					-- #### TEST #### --
					STATE_TEST <= X"08";
					--################--
					block_sel <= "01";
					IF ready ='1' THEN  
						State <= Hash_1;
					END IF; 
			-----------------------------------------------------------
			-------------------- State: Hash_1 ------------------------
			-----------------------------------------------------------
				WHEN Hash_1 =>
					-- #### TEST #### --
					STATE_TEST <= X"09";
					--################-- 
					get_hash <= '1';
					State <= SHA_reset;
			-----------------------------------------------------------
			----------------------- State: SHA_reset ------------------
			-----------------------------------------------------------
				WHEN SHA_reset => 
					-- #### TEST #### --
					STATE_TEST <= X"0A";
					--################--
					State <= Second_hash;
					reset_SHA <= '1';
			-----------------------------------------------------------
			-------------------- State: Second_hash -------------------
			-----------------------------------------------------------
				WHEN Second_hash =>
					-- #### TEST #### --
					STATE_TEST <= X"0B";
					--################--
					State <= Second_hash_progress_a;
					block_sel <= "10";
					update_SHA <= '1';
					update_constants <= '1';

			-----------------------------------------------------------
			--------------- State: Second_hash_progress_a -------------
			-----------------------------------------------------------
				WHEN Second_hash_progress_a =>
					-- #### TEST #### --
					STATE_TEST <= X"0C";
					--################--
					block_sel <= "10";
					State <= Second_hash_progress_b;
			-----------------------------------------------------------
			--------------- State: Second_hash_progress_b -------------
			-----------------------------------------------------------
				WHEN Second_hash_progress_b =>
					-- #### TEST #### --
					STATE_TEST <= X"0D";
					--################--
					block_sel <= "10";
					IF ((ready = '1') AND (success = '0')) THEN 
						State <= Increase_Nonce;  
					ELSIF ((ready = '1') AND (success = '1')) THEN 
						State <= Idle;  
					END IF;
			-----------------------------------------------------------
			----------------- State: Second_hash_progress -------------
			-----------------------------------------------------------
				WHEN Increase_Nonce =>
					-- #### TEST #### --
					STATE_TEST <= X"0E";
					--################-- 
					update_nonce <= '1';
					State <= B_1_begin;
			-----------------------------------------------------------
				WHEN others =>
					-- #### TEST #### --
					STATE_TEST <= X"10";
					--################--
					State <= Idle;
			END CASE; 
    		END IF;
	END IF; 
  END PROCESS;
END rtl;
