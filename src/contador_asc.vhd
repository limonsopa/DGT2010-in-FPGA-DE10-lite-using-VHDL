library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_components.all;

entity contador_asc is
	port(clk,en,reset_n: in  std_logic; 
	mov_u, mov_d, mov_c : out std_logic_vector(6 downto 0); 
	mov_gt16, mov_gt40 : out std_logic);
end contador_asc;

architecture arch of contador_asc is
	signal count      : unsigned(7 downto 0) := (others => '0');
	signal cuenta_int : std_logic_vector(7 downto 0);
   signal bcd_int    : std_logic_vector(11 downto 0);

	begin

--------------------------------------------------------------------
-- REGISTRO DEL CONTADOR 0–->255 carrera libre 8 bits
--------------------------------------------------------------------
   process(clk, reset_n)
		begin
			 if reset_n = '0' then
				  count <= (others => '0');

			 elsif rising_edge(clk) then
				  if en = '1' then
						if count = 255 then
							 count <= (others => '0');
						else
							 count <= count + 1;
						end if;
				  end if;
			 end if;
   end process;


   cuenta_int <= std_logic_vector(count);

 --------------------------------------------------------------------
 -- SEÑALES INDICADORAS DE REGLA: 40 + 16*k
 --------------------------------------------------------------------
   mov_gt40 <= '1' when count = 40 else '0';

    -- mov_gt16 debe ser '1' en 40,56,72,88,104,...
   mov_gt16 <= '1'
       when (count >= 40 and ((count - 40) mod 16 = 0)) else '0';

------------------------------------------------------------------
-- BIN a BCD (0–255)
--------------------------------------------------------------------
   BINTO: bintobcd_12 port map(a => cuenta_int, f => bcd_int);
--------------------------------------------------------------------
-- BCD a 7 SEGMENTOS (displays)
--------------------------------------------------------------------
   H_uni: hexa port map(a => bcd_int(3 downto 0),  f => mov_u);
   H_dec: hexa port map(a => bcd_int(7 downto 4),  f => mov_d);
   H_cen: hexa port map(a => bcd_int(11 downto 8), f => mov_c);

end arch;
