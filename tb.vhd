library ieee;
use ieee.std_logic_1164.all;

entity tb_top_level is
end tb_top_level;

architecture tb of tb_top_level is

    component top_level
        port (clk            : in std_logic;
              alarm          : inout std_logic;
              enable_pompa   : in std_logic;
              luas_pompa     : in std_logic_vector (2 downto 0);
              kecepatan_air  : in std_logic_vector (2 downto 0);
              delivery_head  : in std_logic_vector (2 downto 0);
              pump_state     : inout std_logic;
              efisiensi      : out std_logic_vector (19 downto 0);
              debit          : out std_logic_vector (5 downto 0);
              kegiatan_pompa : inout std_logic_vector (1 downto 0);
              level          : in std_logic_vector (1 downto 0);
              temp_input     : in std_logic_vector (6 downto 0);
              level_tank     : out std_logic_vector (1 downto 0);
              temp           : out std_logic_vector (6 downto 0));
    end component;

    -- Signal declaration
    signal clk            : std_logic;
    signal alarm          : std_logic;
    signal enable_pompa   : std_logic;
    signal luas_pompa     : std_logic_vector (2 downto 0);
    signal kecepatan_air  : std_logic_vector (2 downto 0);
    signal delivery_head  : std_logic_vector (2 downto 0);
    signal pump_state     : std_logic;
    signal efisiensi      : std_logic_vector (19 downto 0);
    signal debit          : std_logic_vector (5 downto 0);
    signal kegiatan_pompa : std_logic_vector (1 downto 0);
    signal level          : std_logic_vector (1 downto 0);
    signal temp_input     : std_logic_vector (6 downto 0);
    signal level_tank     : std_logic_vector (1 downto 0);
    signal temp           : std_logic_vector (6 downto 0);

    -- Clock period for simulation
    constant TbPeriod : time := 1000 ns;
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    -- Instantiate the device under test (DUT)
    dut : top_level
    port map (clk            => clk,
              alarm          => alarm,
              enable_pompa   => enable_pompa,
              luas_pompa     => luas_pompa,
              kecepatan_air  => kecepatan_air,
              delivery_head  => delivery_head,
              pump_state     => pump_state,
              efisiensi      => efisiensi,
              debit          => debit,
              kegiatan_pompa => kegiatan_pompa,
              level          => level,
              temp_input     => temp_input,
              level_tank     => level_tank,
              temp           => temp);

    -- Clock generation: toggle every half period
    TbClock <= not TbClock after TbPeriod / 2 when TbSimEnded /= '1' else '0';

    -- Assigning clock to the DUT clock input
    clk <= TbClock;

    -- Stimuli process
    stimuli : process
    begin
        -- Initialize signals
        luas_pompa <= "001";          -- Initial luas_pompa value (for testing)
        kecepatan_air <= "010";       -- Initial kecepatan_air value
        delivery_head <= "011";      -- Initial delivery_head value
        enable_pompa <= '1';         -- Enable pump at the beginning
        level <= "00";               -- Start at low level
        temp_input <= "1001010";     -- Example temperature input (75 in decimal)

        -- Stimulus 1: Test with LOW level water, system should activate pump after a delay
        wait for 10 * TbPeriod;

        -- Stimulus 2: Test with NORMAL level water, pump should stop
        level <= "01";               -- Normal level input
        wait for 10 * TbPeriod;

        -- Stimulus 3: Test with HIGH level water, pump should still be off
        level <= "11";               -- High level input
        wait for 10 * TbPeriod;

        -- Stimulus 4: Test with different temperature
        temp_input <= "1100001";     -- Example temperature input (97 in decimal)
        wait for 10 * TbPeriod;

        -- Stimulus 5: Test pump off condition
        enable_pompa <= '0';         -- Disable pump
        level <= "00";               -- Low level input again to check if pump stays off
        wait for 10 * TbPeriod;

        -- Stimulus 6: Re-enable pump and simulate different conditions
        enable_pompa <= '1';         -- Enable pump again
        level <= "01";               -- Normal level input
        wait for 10 * TbPeriod;

        -- Stop the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block for simulator compatibility
configuration cfg_tb_top_level of tb_top_level is
    for tb
    end for;
end cfg_tb_top_level;