library ieee;
use ieee.std_logic_1164.all;

entity tb_Tank is
end tb_Tank;

architecture tb of tb_Tank is

    component Tank
        port (level      : in std_logic_vector (1 downto 0);
              temp_input : in std_logic_vector (6 downto 0);
              pump_state : in std_logic;
              clock      : in std_logic;
              level_tank : out std_logic_vector (1 downto 0);
              alarm      : out std_logic;
              temp       : out std_logic_vector (6 downto 0));
    end component;

    signal level      : std_logic_vector (1 downto 0);
    signal temp_input : std_logic_vector (6 downto 0);
    signal pump_state : std_logic;
    signal clock      : std_logic;
    signal level_tank : std_logic_vector (1 downto 0);
    signal alarm      : std_logic;
    signal temp       : std_logic_vector (6 downto 0);

    constant TbPeriod : time := 1000 ns; -- Perioda clock 1000 ns (1 MHz)
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    -- Instansiasi entitas Tank
    dut : Tank
    port map (level      => level,
              temp_input => temp_input,
              pump_state => pump_state,
              clock      => clock,
              level_tank => level_tank,
              alarm      => alarm,
              temp       => temp);

    -- Clock generation (500 ns high dan 500 ns low)
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clock <= TbClock;

    -- Stimulus untuk variasi kondisi
    stimuli : process
    begin
        -- Inisialisasi awal
        level <= "00";       -- LOW level
        temp_input <= "0000000";  -- Suhu 0 derajat Celcius
        pump_state <= '0';   -- Pompa OFF
        wait for 10 * TbPeriod;  -- Tunggu 10 clock period
        
        -- Level = LOW, pompa OFF, suhu 10 derajat
        level <= "00";       -- LOW level
        temp_input <= "0001010";  -- Suhu 10 derajat Celcius
        pump_state <= '0';   -- Pompa OFF
        wait for 10 * TbPeriod;

        -- Level = NORMAL, pompa ON, suhu 25 derajat
        level <= "01";       -- NORMAL level
        temp_input <= "0011001";  -- Suhu 25 derajat Celcius
        pump_state <= '1';   -- Pompa ON
        wait for 10 * TbPeriod;

        -- Level = HIGH, pompa ON, suhu 30 derajat
        level <= "11";       -- HIGH level
        temp_input <= "0011110";  -- Suhu 30 derajat Celcius
        pump_state <= '1';   -- Pompa ON
        wait for 10 * TbPeriod;

        -- Level = LOW lagi, pompa OFF, suhu 5 derajat
        level <= "00";       -- LOW level
        temp_input <= "0000101";  -- Suhu 5 derajat Celcius
        pump_state <= '0';   -- Pompa OFF
        wait for 10 * TbPeriod;

        -- Level = NORMAL, pompa OFF, suhu 20 derajat
        level <= "01";       -- NORMAL level
        temp_input <= "0010100";  -- Suhu 20 derajat Celcius
        pump_state <= '0';   -- Pompa OFF
        wait for 10 * TbPeriod;

        -- Level = HIGH, pompa OFF, suhu 35 derajat
        level <= "11";       -- HIGH level
        temp_input <= "0100010";  -- Suhu 35 derajat Celcius
        pump_state <= '0';   -- Pompa OFF
        wait for 10 * TbPeriod;

        -- Menghentikan simulasi
        TbSimEnded <= '1';  -- Stop simulation
        wait;
    end process;

end tb;

-- Configuration block (tidak perlu diubah dalam kebanyakan kasus)
configuration cfg_tb_Tank of tb_Tank is
    for tb
    end for;
end cfg_tb_Tank;