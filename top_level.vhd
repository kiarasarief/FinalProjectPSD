LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY top_level IS
    PORT (
        --pump
        clk : IN STD_LOGIC;
        alarm : INOUT STD_LOGIC;
        enable_pompa : INOUT STD_LOGIC;
        luas_pompa : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        kecepatan_air : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        delivery_head : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        pump_state : OUT STD_LOGIC;
        efisiensi : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
        debit : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
        kegiatan_pompa : INOUT STD_LOGIC_VECTOR(1 DOWNTO 0);


        --tank
        level : in STD_LOGIC_VECTOR(1 downto 0);  -- 2-bit input untuk level air (00 = low, 01 = normal, 11 = high)
        temp_input : in STD_LOGIC_VECTOR(6 downto 0); -- Suhu air (7-bit)
        --clock : in STD_LOGIC;       -- Clock signal (untuk kontrol waktu)

        -- Outputs
        level_tank : out STD_LOGIC_VECTOR(1 downto 0); -- Menunjukkan level air
        --alarm_tank : out STD_LOGIC;       -- Alarm (1 = menyala, 0 = mati)
        temp : out STD_LOGIC_VECTOR(6 downto 0)        -- Output suhu air (7-bit)
    );
END ENTITY top_level;

ARCHITECTURE rtl OF top_level IS
    COMPONENT pompa IS
        PORT (
            clk : IN STD_LOGIC;
            alarm_pompa : IN STD_LOGIC;
            enable_pompa : INOUT STD_LOGIC;
            pump_state : OUT STD_LOGIC;
            luas_pompa : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            kecepatan_air : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            delivery_head : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            efisiensi : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
            debit : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
            kegiatan_pompa : INOUT STD_LOGIC_VECTOR(1 DOWNTO 0)
        );
    END COMPONENT;

    component Tank is
        port(
            level : in STD_LOGIC_VECTOR(1 downto 0);  -- 2-bit input untuk level air (00 = low, 01 = normal, 11 = high)
            temp_input : in STD_LOGIC_VECTOR(6 downto 0); -- Suhu air (7-bit)
            clock : in STD_LOGIC;       -- Clock signal (untuk kontrol waktu)
    
            -- Outputs
            level_tank : out STD_LOGIC_VECTOR(1 downto 0); -- Menunjukkan level air
            alarm_tank : out STD_LOGIC;       -- Alarm (1 = menyala, 0 = mati)
            temp : out STD_LOGIC_VECTOR(6 downto 0)        -- Output suhu air (7-bit)
        );
    end component;

    
    type StateType IS (MENGISI, GABUT);
    signal current_state : StateType := GABUT;
BEGIN
    u_pompa : pompa
    PORT MAP(
        clk => clk,
        alarm_pompa => alarm,
        enable_pompa => enable_pompa,
        pump_state => pump_state,
        luas_pompa => luas_pompa,
        kecepatan_air => kecepatan_air,
        delivery_head => delivery_head,
        efisiensi => efisiensi,
        debit => debit,
        kegiatan_pompa => kegiatan_pompa
    );

    u_tank : Tank
    port map(
        level => level,
        temp_input => temp_input,
        clock => clk,
        level_tank => level_tank,
        alarm_tank => alarm,
        temp => temp
    );

    process(clk)
    begin
        if falling_edge(clk) then
            if kegiatan_pompa = "00" and current_state = GABUT then
                current_state <= MENGISI;
            elsif kegiatan_pompa = "01" and current_state = MENGISI then
                current_state <= GABUT;
            end if;
        end if;
    end process;
END ARCHITECTURE rtl;