library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity tester_mine is
end tester_mine;

architecture rtl of tester_mine is

component miner is 
PORT (clock:    IN STD_LOGIC;
      reset:    IN STD_LOGIC;
      start: 	IN STD_LOGIC;
      target : IN STD_LOGIC_VECTOR(255 downto 0);
      header : IN STD_LOGIC_VECTOR(1023 downto 0);
      nonce : OUT STD_LOGIC_VECTOR(11 downto 0);
      hash_output : OUT STD_LOGIC_VECTOR(255 downto 0);
      -- ####### FOR TESTING PURPOSES ####### --
      -- FOR STATEM --
      STATE_TEST_MINER : OUT STD_LOGIC_VECTOR(7 downto 0);
      SUCCESS_I_FSM : OUT STD_LOGIC;
      GET_HASH_O_FSM : OUT STD_LOGIC;
      UPDATE_NONCE_O_FSM : OUT STD_LOGIC;
      RESET_NONCE_O_FSM : OUT STD_LOGIC;
      FETCH_O_FSM : OUT STD_LOGIC;
      BLOCK_SEL_O_FSM : OUT STD_LOGIC_VECTOR(1 downto 0);
      UPDATE_SHA_O_FSM : OUT STD_LOGIC;
      UPDATE_CONSTANTS_O_FSM : OUT STD_LOGIC;
      RESET_SHA_O_FSM : OUT STD_LOGIC;
      SHA_ENABLE_O_FSM : OUT STD_LOGIC;
      SAVE_CONSTANTS_0_FSM : OUT STD_LOGIC;
      READY_I_FSM  : OUT STD_LOGIC;
      START_I_FSM  : OUT STD_LOGIC;
      -- FOR BLOCK 0 --
      FETCH_I_B0 : OUT STD_LOGIC;
      HEADER_VALUE_I_B0 : OUT STD_LOGIC_VECTOR(511 downto 0);
      WORD_ADRREES_I_B0 : OUT STD_LOGIC_VECTOR(3 downto 0);
      OUTPUT_O_B0 : OUT STD_LOGIC_VECTOR(31 downto 0);
      -- FOR BLOCK 1 --
      FETCH_I_B1 : OUT STD_LOGIC;
      UPDATE_NONCE_I_B1 : OUT STD_LOGIC;
      NONCE_O_B1 : OUT STD_LOGIC_VECTOR(31 downto 0);
      HEADER_I_B1 : OUT STD_LOGIC_VECTOR(511 downto 0);
      WORD_ADRRESS_I_B1 : OUT STD_LOGIC_VECTOR(3 downto 0);
      OUTPUT_O_B1 : OUT STD_LOGIC_VECTOR(31 downto 0);
      -- FOR HASH_OUTPUT_BLOCK --
      GET_HASH_I_B2 : OUT STD_LOGIC;
      WORD_ADRRESS_I_B2 : OUT STD_LOGIC_VECTOR(3 downto 0);
      OUTPUT_O_B2 : OUT STD_LOGIC_VECTOR(31 downto 0);
      SHA_OUTPUT_I_B2 : OUT STD_LOGIC_VECTOR(255 downto 0);
      -- MUX BETWEEN B(0-2) --
      MUX_BLOCKS : OUT STD_LOGIC_VECTOR(31 downto 0); 
      -- FOR NONCE --
      UPDATE_NONCE_I : OUT STD_LOGIC;
      RESET_NONCE_I  : OUT STD_LOGIC;
      NONCE_I : OUT STD_LOGIC_VECTOR(31 downto 0);
      NONCE_O: OUT STD_LOGIC_VECTOR(31 downto 0);
      -- FOR SHA --
      ENABLE_I_SHA  : OUT STD_LOGIC;
      RESET_I_SHA  : OUT STD_LOGIC;
      UPDATE_I_SHA  : OUT STD_LOGIC;
      READY_O_SHA  : OUT STD_LOGIC;
      WORD_ADRRESS_O_SHA : OUT STD_LOGIC_VECTOR(3 downto 0);
      WORD_I_SHA :  OUT STD_LOGIC_VECTOR(31 downto 0);
      HASH_O_SHA  : OUT STD_LOGIC_VECTOR(255 downto 0);
      H0_I_SHA :  OUT STD_LOGIC_VECTOR(31 downto 0);
      H1_I_SHA :  OUT STD_LOGIC_VECTOR(31 downto 0);
      H2_I_SHA :  OUT STD_LOGIC_VECTOR(31 downto 0);
      H3_I_SHA :  OUT STD_LOGIC_VECTOR(31 downto 0);
      H4_I_SHA :  OUT STD_LOGIC_VECTOR(31 downto 0);
      H5_I_SHA :  OUT STD_LOGIC_VECTOR(31 downto 0);
      H6_I_SHA :  OUT STD_LOGIC_VECTOR(31 downto 0);
      H7_I_SHA :  OUT STD_LOGIC_VECTOR(31 downto 0);
      -- ####### FOR TESTING PURPOSES ####### --
      hash_ready : OUT STD_LOGIC ); 
END COMPONENT;

signal clock: std_logic;
signal reset_t: std_logic;
signal start_t: std_logic;
signal hash_ready_t: std_logic;
signal target_t: std_logic_vector(255 downto 0);
signal header_t: std_logic_vector(1023 downto 0);
signal nonce_t: std_logic_vector(11 downto 0);
signal hash_output_t: std_logic_vector(255 downto 0);
-- FOR STATEM --
signal STATE_TEST_MINER_T : std_logic_vector(7 downto 0);
signal GET_HASH_O_FSM : STD_LOGIC;
signal UPDATE_NONCE_O_FSM :STD_LOGIC;
signal RESET_NONCE_O_FSM : STD_LOGIC;
signal FETCH_O_FSM : STD_LOGIC;
signal BLOCK_SEL_O_FSM : STD_LOGIC_VECTOR(1 downto 0);
signal UPDATE_SHA_O_FSM :  STD_LOGIC;
signal UPDATE_CONSTANTS_O_FSM : STD_LOGIC;
signal RESET_SHA_O_FSM : STD_LOGIC;
signal SHA_ENABLE_O_FSM : STD_LOGIC;
signal SAVE_CONSTANTS_0_FSM : STD_LOGIC;
signal SUCCESS_I_FSM_T : STD_LOGIC;
signal READY_I_FSM  : STD_LOGIC;
signal START_I_FSM  : STD_LOGIC;
-- FOR BLOCK 0 --
signal FETCH_I_B0 : STD_LOGIC;
signal HEADER_VALUE_I_B0 : STD_LOGIC_VECTOR(511 downto 0);
signal WORD_ADRREES_I_B0 : STD_LOGIC_VECTOR(3 downto 0);
signal OUTPUT_O_B0 : STD_LOGIC_VECTOR(31 downto 0);
-- FOR BLOCK 1 --
signal FETCH_I_B1 : STD_LOGIC;
signal UPDATE_NONCE_I_B1 : STD_LOGIC;
signal NONCE_O_B1 : STD_LOGIC_VECTOR(31 downto 0);
signal HEADER_I_B1 : STD_LOGIC_VECTOR(511 downto 0);
signal WORD_ADRRESS_I_B1 :STD_LOGIC_VECTOR(3 downto 0);
signal OUTPUT_O_B1 : STD_LOGIC_VECTOR(31 downto 0);
-- FOR HASH_OUTPUT_BLOCK --
signal GET_HASH_I_B2 : STD_LOGIC;
signal WORD_ADRRESS_I_B2 :  STD_LOGIC_VECTOR(3 downto 0);
signal OUTPUT_O_B2 :  STD_LOGIC_VECTOR(31 downto 0);
signal SHA_OUTPUT_I_B2 : STD_LOGIC_VECTOR(255 downto 0);
-- MUX BETWEEN B(0-2) --
signal MUX_BLOCKS : STD_LOGIC_VECTOR(31 downto 0); 
-- FOR NONCE --
signal UPDATE_NONCE_I : STD_LOGIC;
signal RESET_NONCE_I  : STD_LOGIC;
signal NONCE_I : STD_LOGIC_VECTOR(31 downto 0);
signal NONCE_O:  STD_LOGIC_VECTOR(31 downto 0);
-- FOR SHA --
signal ENABLE_I_SHA  : STD_LOGIC;
signal RESET_I_SHA  : STD_LOGIC;
signal UPDATE_I_SHA  : STD_LOGIC;
signal READY_O_SHA  : STD_LOGIC;
signal WORD_ADRRESS_O_SHA : STD_LOGIC_VECTOR(3 downto 0);
signal WORD_I_SHA :  STD_LOGIC_VECTOR(31 downto 0);
signal HASH_O_SHA  : STD_LOGIC_VECTOR(255 downto 0);
signal H0_I_SHA : STD_LOGIC_VECTOR(31 downto 0);
signal H1_I_SHA : STD_LOGIC_VECTOR(31 downto 0);
signal H2_I_SHA : STD_LOGIC_VECTOR(31 downto 0);
signal H3_I_SHA : STD_LOGIC_VECTOR(31 downto 0);
signal H4_I_SHA : STD_LOGIC_VECTOR(31 downto 0);
signal H5_I_SHA : STD_LOGIC_VECTOR(31 downto 0);
signal H6_I_SHA : STD_LOGIC_VECTOR(31 downto 0);
signal H7_I_SHA : STD_LOGIC_VECTOR(31 downto 0);

begin
	-- MINER COMPONENT IS SUBJECT FOR TESTING 
        MINER_TEST : miner
        port map( clock => clock, reset => reset_t, start => start_t , target => target_t, 
		  header => header_t, nonce => nonce_t, hash_output => hash_output_t, STATE_TEST_MINER => STATE_TEST_MINER_T,
		  SUCCESS_I_FSM => SUCCESS_I_FSM_T, GET_HASH_O_FSM => GET_HASH_O_FSM,  UPDATE_NONCE_O_FSM => UPDATE_NONCE_O_FSM,
      		  RESET_NONCE_O_FSM => RESET_NONCE_O_FSM, FETCH_O_FSM => FETCH_O_FSM, BLOCK_SEL_O_FSM => BLOCK_SEL_O_FSM,
      		  UPDATE_SHA_O_FSM => UPDATE_SHA_O_FSM,UPDATE_CONSTANTS_O_FSM => UPDATE_CONSTANTS_O_FSM,
                  RESET_SHA_O_FSM => RESET_SHA_O_FSM, SHA_ENABLE_O_FSM => SHA_ENABLE_O_FSM, SAVE_CONSTANTS_0_FSM => SAVE_CONSTANTS_0_FSM,
      		  READY_I_FSM  => READY_I_FSM, START_I_FSM  => START_I_FSM,
		  -- FOR BLOCK 0 --
     		  FETCH_I_B0 => FETCH_I_B0, HEADER_VALUE_I_B0 => HEADER_VALUE_I_B0, 
		  WORD_ADRREES_I_B0 => WORD_ADRREES_I_B0, OUTPUT_O_B0  => OUTPUT_O_B0,
		  -- FOR BLOCK 1 --
      		  FETCH_I_B1 => FETCH_I_B1,UPDATE_NONCE_I_B1 => UPDATE_NONCE_I_B1, NONCE_O_B1 => NONCE_O_B1,
   		  HEADER_I_B1 => HEADER_I_B1, WORD_ADRRESS_I_B1 => WORD_ADRRESS_I_B1, OUTPUT_O_B1 => OUTPUT_O_B1,
      		  -- FOR HASH_OUTPUT_BLOCK --
      		  GET_HASH_I_B2 => GET_HASH_I_B2, WORD_ADRRESS_I_B2 => WORD_ADRRESS_I_B2, OUTPUT_O_B2 => OUTPUT_O_B2,
      		  SHA_OUTPUT_I_B2 => SHA_OUTPUT_I_B2,
      		  -- MUX BETWEEN B(0-2) --
      		  MUX_BLOCKS => MUX_BLOCKS,
      		  -- FOR NONCE --
     		  UPDATE_NONCE_I => UPDATE_NONCE_I, RESET_NONCE_I  => RESET_NONCE_I, NONCE_I => NONCE_I,NONCE_O => NONCE_O,
      		  -- FOR SHA --
      		  ENABLE_I_SHA  => ENABLE_I_SHA, RESET_I_SHA   => RESET_I_SHA,UPDATE_I_SHA  => UPDATE_I_SHA,
      		  READY_O_SHA  => READY_O_SHA, WORD_ADRRESS_O_SHA => WORD_ADRRESS_O_SHA, WORD_I_SHA => WORD_I_SHA,
      		  HASH_O_SHA  => HASH_O_SHA, H0_I_SHA => H0_I_SHA, H1_I_SHA => H1_I_SHA, H2_I_SHA => H2_I_SHA, 
		  H3_I_SHA => H3_I_SHA, H4_I_SHA => H4_I_SHA, H5_I_SHA => H5_I_SHA, H6_I_SHA => H6_I_SHA, H7_I_SHA => H7_I_SHA,
		
		   hash_ready => hash_ready_t);

	-- clean all data and put state in IDLE
        RESET : process
        begin
          reset_t <= '1', '0' after 5 ns; 
          start_t <= '1', '0' after 30 ns; 
          wait;
        end process reset;


	-- CLOCK SIMULTAION
        CLK: process 
        begin
                clock <= '0';
                for i in 0 to 100000 loop 
                        wait for 10 ns;
                        clock <= not clock;			
                end loop;  
                wait;
        end process clk;

	-- TEST BODY
	test_body: process 
        begin	
		
		target_t <= X"00000000000000001B7B74000000000000000000000000000000000000000000";
		header_t <= X"02000000671D0E2FF45DD1E927A51219D1CA1065C93B0C4E8840290A00000000000000002CD900FC3513260DF5BD2EABFD456CD2B3D2BACE30CC078215A907C045F4992E74749054747B1B1843F740C0800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000280";		
        	wait;
	end process test_body;

end architecture rtl;
