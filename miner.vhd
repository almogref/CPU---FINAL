library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.ALL;

-----------------------------------------------
--------------- MINER - VHDL ------------------
-----------------------------------------------

ENTITY miner is
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
END miner;
Architecture rtl of miner is

--################# Signals ###################--

--############################--
-------- statem signals ---------
--############################--
SIGNAL get_hash_fsm : STD_LOGIC;
SIGNAL update_nonce_fsm : STD_LOGIC;
SIGNAL reset_nonce_fsm : STD_LOGIC;
SIGNAL fetch_fsm : STD_LOGIC;
SIGNAL sel_fsm : STD_LOGIC_VECTOR(1 downto 0);
SIGNAL update_SHA_fsm : STD_LOGIC;
SIGNAL update_constants_fsm : STD_LOGIC;
SIGNAL reset_SHA_fsm : STD_LOGIC;
SIGNAL save_constants_fsm : STD_LOGIC;
SIGNAL hash_ready_fsm : STD_LOGIC;
SIGNAL sha_enable_fsm : STD_LOGIC;

--############################--
--------- SHA signals -----------
--############################--
SIGNAL ready_sha : STD_LOGIC;
SIGNAL word_address_sha  :  std_logic_vector(3 downto 0);
SIGNAL output_sha       : std_logic_vector(255 downto 0);

--############################--
---- constants-block signals ----
--############################--
SIGNAL output_constants_block     : std_logic_vector(255 downto 0);

--############################--
----- target_block signals ------
--############################--
SIGNAL output_target_block     : std_logic_vector(255 downto 0);

--############################--
---- comapre_target signals -----
--############################--
SIGNAL success_comapre : STD_LOGIC;
SIGNAL hash_output_compare  : std_logic_vector(255 downto 0);


--############################--
-- constants hash block signals -
--############################--
SIGNAL h0_before_hash_output : std_logic_vector(31 downto 0);
SIGNAL h1_before_hash_output : std_logic_vector(31 downto 0);
SIGNAL h2_before_hash_output:  std_logic_vector(31 downto 0);
SIGNAL h3_before_hash_output:  std_logic_vector(31 downto 0);
SIGNAL h4_before_hash_output:  std_logic_vector(31 downto 0);
SIGNAL h5_before_hash_output:  std_logic_vector(31 downto 0);
SIGNAL h6_before_hash_output:  std_logic_vector(31 downto 0);
SIGNAL h7_before_hash_output:  std_logic_vector(31 downto 0);

--############################--
-------- block_0 signals --------
--############################--
SIGNAL output_block_0:  std_logic_vector(31 downto 0);

--############################--
-------- block_0 signals --------
--############################--
SIGNAL output_block_1:  std_logic_vector(31 downto 0);

--############################--
--------- nonce signals ---------
--############################--
SIGNAL output_nonce:  std_logic_vector(31 downto 0);

--############################--
-- output_hash_block signals ---
--############################--
SIGNAL output_hash_block:  std_logic_vector(31 downto 0);

--############################--
------ GENERAL USE signals -----
--############################--
SIGNAL word_input_mux    :  std_logic_vector(31 downto 0);

--############################--
---------- BEGIN ---------------
--############################--
BEGIN 
  ---------------------------------------------------
  ---------------  StateMachine   ------------------- 
  ---------------------------------------------------
  StateMachine:
    entity work.statem
    port map
      (clock     => clock,
      reset	 => reset,
      start 	 => start,
      success 	 => success_comapre,
      ready 	 => ready_sha,
      get_hash 	 => get_hash_fsm,
      update_nonce  => update_nonce_fsm,
      reset_nonce  => reset_nonce_fsm, 	
      fetch  => fetch_fsm,
      block_sel  => sel_fsm,
      update_SHA => update_SHA_fsm,
      update_constants  => update_constants_fsm,
      reset_SHA => reset_SHA_fsm,
      sha_enable => sha_enable_fsm,
      save_constants  => save_constants_fsm,
      -- ####### FOR TESTING PURPOSES ####### --
      STATE_TEST => STATE_TEST_MINER,
      -- ####### FOR TESTING PURPOSES ####### --
      hash_ready => hash_ready
      );


      -- ####### FOR TESTING PURPOSES ####### --
      -- ####### FOR TESTING PURPOSES ####### --
      GET_HASH_O_FSM  <= get_hash_fsm;
      UPDATE_NONCE_O_FSM <= update_nonce_fsm;
      RESET_NONCE_O_FSM <= reset_nonce_fsm;
      FETCH_O_FSM <= fetch_fsm;
      BLOCK_SEL_O_FSM <= sel_fsm;
      UPDATE_SHA_O_FSM <= update_SHA_fsm;
      UPDATE_CONSTANTS_O_FSM <= update_constants_fsm;
      RESET_SHA_O_FSM <= reset_SHA_fsm;
      SHA_ENABLE_O_FSM <= sha_enable_fsm;
      SAVE_CONSTANTS_0_FSM <= save_constants_fsm;
      SUCCESS_I_FSM <= success_comapre;
      READY_I_FSM  <= ready_sha;
      START_I_FSM  <= start;
      -- ####### FOR TESTING PURPOSES ####### --
      -- ####### FOR TESTING PURPOSES ####### --

  ---------------------------------------------------
  -------------------  SHA256  ---------------------- 
  ---------------------------------------------------
  SHA256:
    entity work.sha256
    port map
	(clk    => clock,
	reset   => reset,
	enable  => sha_enable_fsm,
	update_constants => update_constants_fsm,
	h0_before => h0_before_hash_output,
	h1_before => h1_before_hash_output,
	h2_before => h2_before_hash_output,
	h3_before => h3_before_hash_output,
	h4_before => h4_before_hash_output,
	h5_before => h5_before_hash_output,
	h6_before => h6_before_hash_output,
	h7_before => h7_before_hash_output,
	ready  => ready_sha,
	update => update_SHA_fsm,
	word_address => word_address_sha,
	word_input   => word_input_mux,
	hash_output  => output_sha
	);
      -- ####### FOR TESTING PURPOSES ####### --
      -- ####### FOR TESTING PURPOSES ####### --
      ENABLE_I_SHA  <= sha_enable_fsm;
      RESET_I_SHA  <= reset;
      UPDATE_I_SHA <= update_SHA_fsm;
      READY_O_SHA  <= ready_sha;
      WORD_ADRRESS_O_SHA <= word_address_sha;
      WORD_I_SHA <= word_input_mux;
      HASH_O_SHA <= output_sha;
      H0_I_SHA <= h0_before_hash_output;
      H1_I_SHA <= h1_before_hash_output;
      H2_I_SHA <= h2_before_hash_output;
      H3_I_SHA <= h3_before_hash_output;
      H4_I_SHA <= h4_before_hash_output;
      H5_I_SHA <= h5_before_hash_output;
      H6_I_SHA <= h6_before_hash_output;
      H7_I_SHA <= h7_before_hash_output;
      -- ####### FOR TESTING PURPOSES ####### --
      -- ####### FOR TESTING PURPOSES ####### --

  hash_output <= hash_output_compare; -- output from SHA-256
  ---------------------------------------------------
  -----------  constants hash-block  ----------------
  ---------------------------------------------------
  ConstantsBlock:
    entity work.constants_hash_b0
    port map
    	(clock => clock,
    	save_constants =>  save_constants_fsm,
   	sha_output     =>  output_sha,
    	h0_before      =>  h0_before_hash_output,
    	h1_before      =>  h1_before_hash_output,
    	h2_before      =>  h2_before_hash_output,     
    	h3_before      =>  h3_before_hash_output,
    	h4_before      =>  h4_before_hash_output,
    	h5_before      =>  h5_before_hash_output,
    	h6_before      =>  h6_before_hash_output,
    	h7_before      =>  h7_before_hash_output
   	 );
 
  ---------------------------------------------------
  ----------------  target_block  -------------------
  ---------------------------------------------------
  TargetBlock:
    entity work.target_block
    port map
    	(clock  => clock,
    	fetch   => fetch_fsm,
    	target_in => target,
    	target_out  => output_target_block
    );

  ---------------------------------------------------
  ---------------  compare_target  ------------------
  ---------------------------------------------------
  Comapre:
    entity work.compare_target
    port map
    	(clock => clock,
	ready  => ready_sha,
    	target  => output_target_block,
    	hash_output =>  output_sha,
	hash_output_register => hash_output_compare,
    	success  => success_comapre
    	);


  -- ####### FOR TESTING PURPOSES ####### --
  --SUCCESS_TEST <= success_comapre;
  -- ####### FOR TESTING PURPOSES ####### --

  ---------------------------------------------------
  --------------  hash_output_block  ----------------
  ---------------------------------------------------
  HashBlock:
    entity work.hash_output_block
    port map
    	(clock => clock,
    	get_hash => get_hash_fsm,
   	word_adrress => word_address_sha,
    	sha_output  => output_sha,
    	output  => output_hash_block
    );

      -- ####### FOR TESTING PURPOSES ####### --
      -- ####### FOR TESTING PURPOSES ####### --
      GET_HASH_I_B2  <= get_hash_fsm;
      WORD_ADRRESS_I_B2 <= word_address_sha;
      SHA_OUTPUT_I_B2 <= output_sha;
      OUTPUT_O_B2 <= output_hash_block;
      -- ####### FOR TESTING PURPOSES ####### --
      -- ####### FOR TESTING PURPOSES ####### --

  ---------------------------------------------------
  -------------------  block 0  ---------------------
  ---------------------------------------------------
  Block0:
    entity work.block_0
    port map
    	(clock  => clock,
    	fetch   => fetch_fsm,
    	header_value => header(511 downto 0),
    	word_adrress => word_address_sha,
    	output  => output_block_0
    );
      -- ####### FOR TESTING PURPOSES ####### --
      -- ####### FOR TESTING PURPOSES ####### --
      FETCH_I_B0 <= fetch_fsm;
      HEADER_VALUE_I_B0 <= header(511 downto 0);
      WORD_ADRREES_I_B0 <= word_address_sha;
      OUTPUT_O_B0 <= output_block_0;
      -- ####### FOR TESTING PURPOSES ####### --
      -- ####### FOR TESTING PURPOSES ####### --


  ---------------------------------------------------
  -------------------  block 1  ---------------------
  ---------------------------------------------------
  Block1:
    entity work.block_1
    port map
    	(clock => clock,
    	fetch => fetch_fsm,
    	nonce_update => update_constants_fsm,
    	nonce => output_nonce,
    	header_value => header(1023 downto 512),
    	word_adrress => word_address_sha,
    	output  => output_block_1
      );

      -- ####### FOR TESTING PURPOSES ####### --
      -- ####### FOR TESTING PURPOSES ####### --
      FETCH_I_B1 <= fetch_fsm;
      UPDATE_NONCE_I_B1 <= update_constants_fsm;
      NONCE_O_B1 <= output_nonce;
      HEADER_I_B1 <= header(1023 downto 512);
      WORD_ADRRESS_I_B1 <= word_address_sha;
      OUTPUT_O_B1 <= output_block_1;
      MUX_BLOCKS <= word_input_mux;
      -- ####### FOR TESTING PURPOSES ####### --
      -- ####### FOR TESTING PURPOSES ####### --


   ---------------------------------------------------
   -- Mux between the blocks: block0,block1 or hash_output_block --
   word_input_mux <= output_block_1 when sel_fsm = "01" else output_hash_block  
		     when sel_fsm = "10" else output_block_0;
  --------------------------------------------------- 

  ---------------------------------------------------
  --------------------  nonce -----------------------
  ---------------------------------------------------
  NonceMoudle:
    entity work.nonce
    port map
    	(clock  => clock,
    	reset   => reset_nonce_fsm,
    	update_nonce  => update_nonce_fsm,
    	nonce => header(1023 downto 992),
    	updated_nonce => output_nonce
    );
 
      -- ####### FOR TESTING PURPOSES ####### --
      -- ####### FOR TESTING PURPOSES ####### --
      UPDATE_NONCE_I <= update_nonce_fsm;
      RESET_NONCE_I  <= reset_nonce_fsm;
      NONCE_I <= header(1023 downto 992);
      NONCE_O <= output_nonce;
      -- ####### FOR TESTING PURPOSES ####### --
      -- ####### FOR TESTING PURPOSES ####### --
  nonce <= output_nonce(31 downto 20); -- Nonce+1
  
  

end rtl;
