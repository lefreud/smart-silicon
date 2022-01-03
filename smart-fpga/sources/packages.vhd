library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package SmartPackage is
    --
    -- Constants
    --

    constant VECTOR_LENGTH : integer := 4;
    
    -- TF32 datatype from NVIDIA
    constant SCALAR_SIGH_LENGTH : integer := 1;
    constant SCALAR_EXPONENT_LENGTH : integer := 8;
    constant SCALAR_MANTISSA_LENGTH : integer := 10;
    constant SCALAR_LENGTH : integer := SCALAR_SIGH_LENGTH + SCALAR_EXPONENT_LENGTH + SCALAR_MANTISSA_LENGTH;
    
    --
    -- Data types
    --
    
    subtype scalar is STD_LOGIC_VECTOR(SCALAR_LENGTH - 1 downto 0);
    type vector is array(VECTOR_LENGTH - 1 downto 0) of scalar;
    type matrix is array(VECTOR_LENGTH - 1 downto 0, VECTOR_LENGTH - 1 downto 0) of scalar;
end package;
