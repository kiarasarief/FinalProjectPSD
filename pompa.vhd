LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY pompa IS
    PORT (
        SIGNAL clk : IN STD_LOGIC;
        SIGNAL alarm : IN STD_LOGIC;
        SIGNAL enable_pompa : INOUT STD_LOGIC;
        SIGNAL pump_state : OUT STD_LOGIC; --tracking state pump, buat tim Tangki silakan output ini jadi input buat tangki
        SIGNAL luas_pompa : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        SIGNAL kecepatan_air : IN STD_LOGIC_VECTOR(2 DOWNTO 0); --sementara 3 bit
        SIGNAL delivery_head : IN STD_LOGIC_VECTOR(2 DOWNTO 0); --sementara 3 bit
        SIGNAL efisiensi : OUT STD_LOGIC_VECTOR(19 DOWNTO 0); --sementara 5 bit
        SIGNAL debit : OUT STD_LOGIC_VECTOR(5 DOWNTO 0); --sementara 5 bit
        SIGNAL kegiatan_pompa : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) --sementara 2 bit
    );
END ENTITY pompa;

ARCHITECTURE Behavioral OF pompa IS
    -- variable" disini buat rumus
    -- daya dan densitas di sini?
    SIGNAL daya : unsigned(10 DOWNTO 0) := "11111010000"; -- 2000 Watt
    SIGNAL densitas : unsigned(10 DOWNTO 0) := "01111101000"; -- 1000 kg/m^3
    SIGNAL faktor_pembagi : UNSIGNED(8 DOWNTO 0) := "101101001"; -- 367
    TYPE StateType IS (MENGISI, GABUT);
    SIGNAL current_state : StateType := GABUT;
BEGIN
    -- PROCESS (clk, kecepatan_air, luas_pompa, delivery_head)
    --     VARIABLE internal_debit : unsigned(5 DOWNTO 0); -- internal signal buat debitnya
    --     VARIABLE efisiensi_temp : INTEGER;-- internal signal buat efisiensi
    --     variable koma : integer;
    -- BEGIN
    --     IF rising_edge(clk) THEN
    --         internal_debit := unsigned(luas_pompa) * unsigned(kecepatan_air);
    --         efisiensi_temp := to_integer((unsigned(internal_debit) * unsigned(delivery_head) * unsigned(densitas) * 10000) / (367 * unsigned(daya))); -- scale by 1000
    --         koma := efisiensi_temp mod 100;

    --         if koma > 50 then
    --             efisiensi_temp := efisiensi_temp + 100;
    --         end if;

    --         efisiensi_temp := efisiensi_temp / 100;

    --         debit <= STD_LOGIC_VECTOR(internal_debit);

    --         efisiensi <= STD_LOGIC_VECTOR(to_unsigned(efisiensi_temp, 20)); -- scaled integer

    --     END IF;
    -- END PROCESS;

    PROCESS (clk, kecepatan_air, luas_pompa, delivery_head)
        VARIABLE internal_debit : unsigned(5 DOWNTO 0); -- internal signal buat debitnya
        VARIABLE efisiensi_temp : INTEGER;-- internal signal buat efisiensi
        VARIABLE koma : INTEGER;
    BEGIN
        IF falling_edge(clk) THEN
            IF enable_pompa = '1' THEN
                IF alarm = '1' AND current_state = GABUT THEN
                    pump_state <= '1';
                    current_state <= MENGISI;
                    kegiatan_pompa <= "01";
                END IF;
            ELSIF enable_pompa = '0' THEN
                REPORT "Pompa mati! Hidupkan dulu bos" SEVERITY warning;
                current_state <= GABUT;
                kegiatan_pompa <= "00";
            END IF;

            internal_debit := unsigned(luas_pompa) * unsigned(kecepatan_air);
            efisiensi_temp := to_integer((unsigned(internal_debit) * unsigned(delivery_head) * unsigned(densitas) * 10000) / (367 * unsigned(daya))); -- scale by 1000
            koma := efisiensi_temp MOD 100;

            IF koma > 50 THEN
                efisiensi_temp := efisiensi_temp + 100;
            END IF;

            efisiensi_temp := efisiensi_temp / 100;

            debit <= STD_LOGIC_VECTOR(internal_debit);

            efisiensi <= STD_LOGIC_VECTOR(to_unsigned(efisiensi_temp, 20)); -- scaled integer
        END IF;
    END PROCESS;
END ARCHITECTURE Behavioral;