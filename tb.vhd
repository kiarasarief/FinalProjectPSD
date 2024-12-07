library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

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

    -- File handling
    file output_file: text;

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

    -- Clock generation
    TbClock <= not TbClock after TbPeriod / 2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;

    -- File writing process
    file_writer: process
        variable line_out: line;
        variable simulation_time: time;
    begin
        -- Open the output file
        file_open(output_file, "pump_output.txt", write_mode);
        
        -- Write header
        write(line_out, string'("Time(ns), Debit, Efisiensi"));
        writeline(output_file, line_out);
        
        while TbSimEnded /= '1' loop
            wait for TbPeriod;  -- Sample every clock period
            
            -- Get current simulation time
            simulation_time := now;
            
            -- Create output line with time, debit, and efisiensi
            write(line_out, simulation_time);
            write(line_out, string'(", "));
            write(line_out, to_integer(unsigned(debit)));
            write(line_out, string'(", "));
            write(line_out, to_integer(unsigned(efisiensi)));
            writeline(output_file, line_out);
        end loop;
        
        -- Close the file
        file_close(output_file);
        wait;
    end process;

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

        -- Stimulus 1: Test with LOW level water
        wait for 10 * TbPeriod;

        -- Stimulus 2: Test with NORMAL level water
        level <= "01";               
        wait for 10 * TbPeriod;

        -- Stimulus 3: Test with HIGH level water
        level <= "11";               
        wait for 10 * TbPeriod;

        -- Stimulus 4: Test with different temperature
        temp_input <= "1100001";     
        wait for 10 * TbPeriod;

        -- Stimulus 5: Test pump off condition
        enable_pompa <= '0';         
        level <= "00";               
        wait for 10 * TbPeriod;

        -- Stimulus 6: Re-enable pump and simulate different conditions
        enable_pompa <= '1';         
        level <= "01";               
        wait for 10 * TbPeriod;

        -- Stop the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block
configuration cfg_tb_top_level of tb_top_level is
    for tb
    end for;
end cfg_tb_top_level;