LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY top_level IS
    PORT (
        clk : IN STD_LOGIC;
        alarm : IN STD_LOGIC;
        enable_pompa : INOUT STD_LOGIC;
        luas_pompa : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        kecepatan_air : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        delivery_head : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        pump_state : OUT STD_LOGIC;
        efisiensi : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
        debit : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
        kegiatan_pompa : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
    );
END ENTITY top_level;

ARCHITECTURE rtl OF top_level IS
    COMPONENT pompa IS
        PORT (
            clk : IN STD_LOGIC;
            alarm : IN STD_LOGIC;
            enable_pompa : INOUT STD_LOGIC;
            pump_state : OUT STD_LOGIC;
            luas_pompa : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            kecepatan_air : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            delivery_head : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            efisiensi : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
            debit : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
            kegiatan_pompa : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
        );
    END COMPONENT;

    type StateType IS (MENGISI, GABUT);
    signal current_state : StateType;
BEGIN
    u_pompa : pompa
    PORT MAP(
        clk => clk,
        alarm => alarm,
        enable_pompa => enable_pompa,
        pump_state => pump_state,
        luas_pompa => luas_pompa,
        kecepatan_air => kecepatan_air,
        delivery_head => delivery_head,
        efisiensi => efisiensi,
        debit => debit
        kegiatan_pompa => kegiatan_pompa
    );
END ARCHITECTURE rtl;