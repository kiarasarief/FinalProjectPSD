library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pompa is
    port (
        signal clk : in std_logic;
        signal alarm : in std_logic;
        signal pompa : inout std_logic;
        signal pump_state : out std_logic; --tracking state pump, buat tim Tangki silakan output ini jadi input buat tangki
        signal luas_pompa : in std_logic_vector(2 downto 0);
        signal kecepatan_air : in std_logic_vector(2 downto 0); --sementara 3 bit
        signal delivery_head : in std_logic_vector(2 downto 0); --sementara 3 bit
        signal efisiensi : out std_logic_vector(5 downto 0); --sementara 5 bit
        signal debit : out std_logic_vector(5 downto 0) --sementara 5 bit
    );
end entity pompa;

architecture Behavioral of pompa is
    -- variable" disini buat rumus
    -- daya dan densitas di sini?
    type StateType is (MENGISI, GABUT);
    signal current_state : StateType;
begin
    process(clk) --sensitivity kalau mau pake)
    begin
        if pompa = '1' then
            if alarm = '1' and current_state = GABUT then
                pump_state <= '1';
                current_state <= MENGISI;
            end if;
            elsif pompa = '0' then
                report "Pompa mati! Hidupkan dulu bos" severity warning;
                current_state <= GABUT;
        end if;
    end process;
end architecture Behavioral;