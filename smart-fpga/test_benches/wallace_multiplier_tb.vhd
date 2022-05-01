library IEEE;
use IEEE.std_logic_1164.all;

entity wallace_multiplier_tb is

end wallace_multiplier_tb;

architecture behavioral of wallace_multiplier_tb is

component wallace_multiplier is
      port (
        a : in std_logic_vector(16 - 1 downto 0);
        b : in std_logic_vector(16 - 1 downto 0);
        c : out std_logic_vector(31 - 1 downto 0)
      );
    end component;
    signal a : std_logic_vector(16 - 1 downto 0);
    signal b : std_logic_vector(16 - 1 downto 0);
    signal c : std_logic_vector(31 - 1 downto 0);
begin

    UUT : wallace_multiplier
        port map (
            a => a,
            b => b,
            c => c
        );
    
    a <= x"abcd";
    b <= x"cdef";
    -- should result with 8A33 8D63

end behavioral;
