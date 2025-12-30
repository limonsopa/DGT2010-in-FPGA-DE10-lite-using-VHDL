library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_components.all;

entity reloj_ajedrez is
	port(reset_n,config,clk,ini_pausa,jugador_act: in std_logic;
			modo,ver_disp: in std_logic_vector(1 downto 0);
			display_0,display_1,display_2,display_3,display_4,display_5: out std_logic_vector(6 downto 0);leds: out std_logic_vector(9 downto 0));
end reloj_ajedrez;

architecture arch of reloj_ajedrez is
	signal en,en_sel,en_j0,en_j1: std_logic;
	signal modo_reg: std_logic_vector(1 downto 0);
	signal min_value_j0,min_value_j1: std_logic;--indican a quien se le acabo la cuenta
	signal ini_pausa_j0,ini_pausa_j1,borrar_j0,borrar_j1,mov_j0_gt40,mov_j1_gt40,mov_gt16_j0,mov_gt16_j1: std_logic;
	signal mov_restricciones_j0,mov_restricciones_j1: std_logic;
	signal mov_u_j0,mov_d_j0,mov_c_j0, mov_u_j1,mov_d_j1,mov_c_j1: std_logic_vector(6 downto 0);
	signal display_0_j0,display_1_j0,display_2_j0,display_3_j0,display_4_j0,display_5_j0: std_logic_vector(6 downto 0);
	signal display_0_j1,display_1_j1,display_2_j1,display_3_j1,display_4_j1,display_5_j1: std_logic_vector(6 downto 0);
	signal en_and_en_j1,en_and_en_j0: std_logic;
	begin
------- Divisor de frecuencia para la máquina de estados -----------------------------------------------------------------------------------------------------------------------------											
	
		div_freq: divisor_freq generic map(N=>10,BUS_WIDTH=>4) port map(reset_n=>reset_n,clk=>clk,clk_o=>en);
		--registro
		registroPIPO: reg_d port map(reset_n=>reset_n,en_sel=>en_sel,clk=>clk,modo=>modo,modo_reg=>modo_reg);
------- Cambio de estados -----------------------------------------------------------------------------------------------------------------------------											

		FSM_moore: fsm port map(reset_n=>reset_n,en=>en,config=>config,
										ini_pausa=>ini_pausa,jugador_act=>jugador_act,
										modo=>modo,min_value_j0=>min_value_j0,
										min_value_j1=>min_value_j1,clk=>clk,
										ini_pausa_j0=>ini_pausa_j0,ini_pausa_j1=>ini_pausa_j1,
										borrar_j0=>borrar_j0,borrar_j1=>borrar_j1,en_sel=>en_sel,
										en_j0=>en_j0,en_j1=>en_j1,
										mov_j0_gt40=>mov_j0_gt40,mov_j1_gt40=>mov_j1_gt40);
										
		--ESTO DE ACA LO AÑADO PARA LOS INDICADORES DE AUMENTAR 1 HORA CUANDO SE CUMPLEN LOS MOV_GT 40 O 40 +16K--								
		mov_restricciones_j0 <= mov_j0_gt40 or mov_gt16_j0;
		mov_restricciones_j1 <=  mov_j1_gt40 or mov_gt16_j1;
------- Reloj del jugador 0 -----------------------------------------------------------------------------------------------------------------------------											
		reloj_j0: reloj port map(reset_n=>reset_n,clk=>clk,
													ini_pausa=>ini_pausa_j0,borrar=>borrar_j0,
													sel=>modo_reg,
													mov_restricciones=>mov_restricciones_j0, --añadi esto para la restriccion de 40 y 40 +16k movimientos
													min_value=>min_value_j0,
													display_0=>display_0_j0,display_1=>display_1_j0,
													display_2=>display_2_j0,display_3=>display_3_j0,
													display_4=>display_4_j0,display_5=>display_5_j0);
													
		en_and_en_j0 <= en and en_j0;
		cont_asc_j0: contador_asc port map(en=>en_and_en_j0, reset_n => reset_n ,clk=>clk,
														mov_u=>mov_u_j0, mov_d=>mov_d_j0, mov_c=>mov_c_j0,
														mov_gt40=>mov_j0_gt40,mov_gt16=>mov_gt16_j0);
		
------- Reloj del jugador 1 -----------------------------------------------------------------------------------------------------------------------------											
		reloj_j1: reloj port map(reset_n=>reset_n,clk=>clk,
													ini_pausa=>ini_pausa_j1,borrar=>borrar_j1,
													sel=>modo_reg,
													min_value=>min_value_j1,
													mov_restricciones=> mov_restricciones_j1, --añadi esto para la restriccion de 40 y 40 +16k movimientos
													display_0=>display_0_j1,display_1=>display_1_j1,
													display_2=>display_2_j1,display_3=>display_3_j1,
													display_4=>display_4_j1,display_5=>display_5_j1);
		en_and_en_j1 <= en and en_j1;
		--contador ascendente											
		cont_asc_j1: contador_asc port map(en=> en_and_en_j1,reset_n=>reset_n,clk=>clk,
												mov_u=>mov_u_j1, mov_d=>mov_d_j1, mov_c=>mov_c_j1,
													mov_gt40=>mov_j1_gt40,mov_gt16=>mov_gt16_j1);
				
------- Displays -----------------------------------------------------------------------------------------------------------------------------															
		Mux4a1_display_0: Mux4a1 port map(a00=>display_0_j0,a01=>mov_u_j0,a10=>display_0_j1,a11=>mov_u_j1,sel=>ver_disp,f=>display_0);											
		Mux4a1_display_1: Mux4a1 port map(a00=>display_1_j0,a01=>mov_d_j0,a10=>display_1_j1,a11=>mov_d_j1,sel=>ver_disp,f=>display_1);
		Mux4a1_display_2: Mux4a1 port map(a00=>display_2_j0,a01=>mov_c_j0,a10=>display_2_j1,a11=>mov_c_j1,sel=>ver_disp,f=>display_2);
		Mux4a1_display_3: Mux4a1 port map(a00=>display_3_j0,a01=>"1111111",a10=>display_3_j1,a11=>"1111111",sel=>ver_disp,f=>display_3);
		Mux4a1_display_4: Mux4a1 port map(a00=>display_4_j0,a01=>"1111111",a10=>display_4_j1,a11=>"1111111",sel=>ver_disp,f=>display_4);
		Mux4a1_display_5: Mux4a1 port map(a00=>display_5_j0,a01=>"1111111",a10=>display_5_j1,a11=>"1111111",sel=>ver_disp,f=>display_5);
--===============================================================================================================================================	
--===================================================== Generador de los LEDS ======================================================
--===============================================================================================================================================
		GEN_LEDS: generador_leds generic map(M=>10) port map(reset=>reset_n,clk=>clk,min_value_j0=>min_value_j0,min_value_j1=>min_value_j1,leds=>leds);
		---EL M se configura para que la señal que salga sea de 1 Hz, esto depende de la señal clk en realidad, que se utilice, por eso tiene M configurable
end arch;







