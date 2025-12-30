library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_horas is
	generic(M : integer := 3;N : integer := 2);
   port(clk, g_reset_n,en,mov_restricciones : in std_logic;
        valor_inicial : in std_logic_vector(N-1 downto 0);
        q : out std_logic_vector(N-1 downto 0));
end counter_horas;

architecture arch of counter_horas is
   signal q_reg : unsigned(N-1 downto 0);
	begin

-- parte secuencial
		process(clk, g_reset_n)
			begin
				if g_reset_n = '0' then
            q_reg <= unsigned(valor_inicial);

				elsif rising_edge(clk) then --flanco de actualizaciones

---------------------prioridad en wccm: AÑADIR 1 HORA EN CASO LOS MOVIMIENTOS SEAN > 40 +16k
--------RECORDAR: Es logica esta fuera del counter, aca las recepciones ya serán correctas--
					if mov_restricciones = '1' then
						 if q_reg < to_unsigned(M-1, N) then
							  q_reg <= q_reg + 1;
						 else
							  q_reg <= q_reg;  -- ya está en 2 horas, no sumar mas pues es el máximo según la guía
						 end if;

---------------SI NO HAY mov_restriccion o no esta habilitado --> CONTEO HABITUAL DECRECIENTE
					elsif en = '1' then
					
						 if q_reg = 0 then
							  q_reg <= to_unsigned(M-1, N);
						 else
							  q_reg <= q_reg - 1;
						 end if;
						 
					end if;
				end if;
		end process;
		--cuent actual
		q <= std_logic_vector(q_reg);

end arch;
