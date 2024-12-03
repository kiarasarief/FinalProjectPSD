LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY pompa IS
    PORT (
        SIGNAL clk : IN STD_LOGIC;
        SIGNAL alarm : OUT STD_LOGIC;
        SIGNAL pompa : INOUT STD_LOGIC;
        SIGNAL tank_state : IN STD_LOGIC_VECTOR(1 DOWNTO 0); --tracking state tangki
        SIGNAL luas_pompa : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        SIGNAL kecepatan_air : IN STD_LOGIC_VECTOR(2 DOWNTO 0); --sementara 3 bit
        SIGNAL delivery_head : IN STD_LOGIC_VECTOR(2 DOWNTO 0); --sementara 3 bit
        SIGNAL efisiensi : OUT STD_LOGIC_VECTOR(5 DOWNTO 0); --sementara 5 bit
        SIGNAL debit : OUT STD_LOGIC_VECTOR(5 DOWNTO 0) --sementara 5 bit
    );
END ENTITY pompa;

ARCHITECTURE Behavioral OF pompa IS
    -- variable" disini buat rumus
    -- daya dan densitas di sini?
    SIGNAL daya : STD_LOGIC_VECTOR(10 DOWNTO 0) := "11111010000"; -- 2000 Watt
    SIGNAL densitas : STD_LOGIC_VECTOR(10 DOWNTO 0) := "01111101000"; -- 1000 kg/m^3
    CONSTANT faktor_pembagi : UNSIGNED(8 DOWNTO 0) := "101101001"; -- 367

BEGIN
    PROCESS (clk)
        VARIABLE internal_debit : STD_LOGIC_VECTOR(5 DOWNTO 0); -- internal signal buat debitnya
        VARIABLE efisiensi_temp : UNSIGNED(15 DOWNTO 0);-- internal signal buat efisiensi

    BEGIN
        IF rising_edge(clk) THEN
            internal_debit := STD_LOGIC_VECTOR(unsigned(luas_pompa) * unsigned(kecepatan_air));

            debit <= internal_debit;

        END IF;
    END PROCESS;
END ARCHITECTURE Behavioral;