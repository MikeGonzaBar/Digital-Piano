`timescale 1ns / 1ps

// Behavioral regression test for the top-level piano module.
// It verifies invalid selections stay silent and every valid note selection
// toggles at the divider interval used by Notes.v.
module Piano_tb;
	reg clk;
	reg reset;
	reg sw1;
	reg sw2;
	reg sw3;
	reg sw4;
	reg sw5;
	reg sw6;
	reg sw7;
	reg btn1;
	reg btn2;
	reg btn3;
	reg btn4;
	wire sound;

	integer failures;

	Piano dut(
		.clk(clk),
		.reset(reset),
		.sw1(sw1),
		.sw2(sw2),
		.sw3(sw3),
		.sw4(sw4),
		.sw5(sw5),
		.sw6(sw6),
		.sw7(sw7),
		.btn1(btn1),
		.btn2(btn2),
		.btn3(btn3),
		.btn4(btn4),
		.sound(sound)
	);

	initial begin
		clk = 1'b0;
		forever #10 clk = ~clk;
	end

	task set_bus;
		input [6:0] sw_value;
		input [3:0] note_value;
		begin
			sw7 = sw_value[0];
			sw6 = sw_value[1];
			sw5 = sw_value[2];
			sw4 = sw_value[3];
			sw3 = sw_value[4];
			sw2 = sw_value[5];
			sw1 = sw_value[6];

			btn4 = note_value[0];
			btn3 = note_value[1];
			btn2 = note_value[2];
			btn1 = note_value[3];
		end
	endtask

	task record_failure;
		input [8*48-1:0] message;
		begin
			failures = failures + 1;
			$display("FAIL: %0s", message);
		end
	endtask

	task reset_dut;
		begin
			set_bus(7'd0, 4'd0);
			reset = 1'b1;
			repeat (4) begin
				@(posedge clk);
				#1;
			end
			if (sound !== 1'b0) begin
				record_failure("sound was not low while reset was asserted");
			end
			reset = 1'b0;
			repeat (2) begin
				@(posedge clk);
				#1;
			end
		end
	endtask

	task wait_for_toggle;
		input integer max_cycles;
		output integer cycles;
		reg previous_sound;
		begin
			previous_sound = sound;
			cycles = 0;
			while ((sound === previous_sound) && (cycles < max_cycles)) begin
				@(posedge clk);
				#1;
				cycles = cycles + 1;
			end
		end
	endtask

	task check_note;
		input [6:0] sw_value;
		input [3:0] note_value;
		input integer divider;
		input [8*8-1:0] note_name;
		integer first_toggle_cycles;
		integer half_period_cycles;
		integer expected_half_period;
		begin
			reset_dut();
			set_bus(sw_value, note_value);
			expected_half_period = divider + 1;

			wait_for_toggle(divider + 20, first_toggle_cycles);
			if (first_toggle_cycles >= (divider + 20)) begin
				record_failure({note_name, " did not start toggling"});
			end

			wait_for_toggle(divider + 20, half_period_cycles);
			if (half_period_cycles != expected_half_period) begin
				$display(
					"FAIL: %0s half-period was %0d cycles, expected %0d",
					note_name,
					half_period_cycles,
					expected_half_period
				);
				failures = failures + 1;
			end

			wait_for_toggle(divider + 20, half_period_cycles);
			if (half_period_cycles != expected_half_period) begin
				$display(
					"FAIL: %0s second half-period was %0d cycles, expected %0d",
					note_name,
					half_period_cycles,
					expected_half_period
				);
				failures = failures + 1;
			end

			if (failures == 0) begin
				$display("PASS: %0s", note_name);
			end
		end
	endtask

	task check_silence;
		input [6:0] sw_value;
		input [3:0] note_value;
		input [8*24-1:0] case_name;
		integer cycles;
		reg saw_sound;
		begin
			reset_dut();
			set_bus(sw_value, note_value);
			saw_sound = 1'b0;
			for (cycles = 0; cycles < 2000; cycles = cycles + 1) begin
				@(posedge clk);
				#1;
				if (sound !== 1'b0) begin
					saw_sound = 1'b1;
				end
			end

			if (saw_sound) begin
				$display("FAIL: %0s produced sound", case_name);
				failures = failures + 1;
			end else begin
				$display("PASS: %0s stayed silent", case_name);
			end
		end
	endtask

	task check_note_change_resets_phase;
		integer cycles;
		begin
			reset_dut();
			set_bus(7'd16, 4'd4);
			wait_for_toggle((25000000 / 440) + 20, cycles);
			if (sound !== 1'b1) begin
				record_failure("A4 did not reach high phase before note change");
			end

			set_bus(7'd64, 4'd8);
			repeat (6) begin
				@(posedge clk);
				#1;
			end

			if (sound !== 1'b0) begin
				record_failure("note change did not reset output phase");
			end else begin
				$display("PASS: note change resets output phase");
			end
		end
	endtask

	initial begin
		$dumpfile("sim/Piano_tb.vcd");
		$dumpvars(0, Piano_tb);

		failures = 0;
		reset = 1'b0;
		set_bus(7'd0, 4'd0);

		check_silence(7'd0, 4'd1, "no switch selected");
		check_silence(7'd1, 4'd0, "no button selected");
		check_silence(7'd3, 4'd1, "multiple switches");
		check_silence(7'd1, 4'd3, "multiple buttons");
		check_note_change_resets_phase();

		check_note(7'd1, 4'd1, 25000000 / 1245, "DS6");
		check_note(7'd1, 4'd2, 25000000 / 1175, "D6");
		check_note(7'd1, 4'd4, 25000000 / 1109, "CS6");
		check_note(7'd1, 4'd8, 25000000 / 1047, "C6");
		check_note(7'd2, 4'd1, 25000000 / 988, "B5");
		check_note(7'd2, 4'd2, 25000000 / 932, "AS5");
		check_note(7'd2, 4'd4, 25000000 / 880, "A5");
		check_note(7'd2, 4'd8, 25000000 / 830, "GS5");
		check_note(7'd4, 4'd1, 25000000 / 784, "G5");
		check_note(7'd4, 4'd2, 25000000 / 740, "FS5");
		check_note(7'd4, 4'd4, 25000000 / 698, "F5");
		check_note(7'd4, 4'd8, 25000000 / 659, "E5");
		check_note(7'd8, 4'd1, 25000000 / 622, "DS5");
		check_note(7'd8, 4'd2, 25000000 / 587, "D5");
		check_note(7'd8, 4'd4, 25000000 / 554, "CS5");
		check_note(7'd8, 4'd8, 25000000 / 523, "C5");
		check_note(7'd16, 4'd1, 25000000 / 494, "B4");
		check_note(7'd16, 4'd2, 25000000 / 466, "AS4");
		check_note(7'd16, 4'd4, 25000000 / 440, "A4");
		check_note(7'd16, 4'd8, 25000000 / 415, "GS4");
		check_note(7'd32, 4'd1, 25000000 / 392, "G4");
		check_note(7'd32, 4'd2, 25000000 / 370, "FS4");
		check_note(7'd32, 4'd4, 25000000 / 349, "F4");
		check_note(7'd32, 4'd8, 25000000 / 330, "E4");
		check_note(7'd64, 4'd1, 25000000 / 311, "DS4");
		check_note(7'd64, 4'd2, 25000000 / 294, "D4");
		check_note(7'd64, 4'd4, 25000000 / 277, "CS4");
		check_note(7'd64, 4'd8, 25000000 / 262, "C4");

		if (failures == 0) begin
			$display("ALL TESTS PASSED");
			$finish;
		end

		$display("TESTS FAILED: %0d failure(s)", failures);
		$finish_and_return(1);
	end
endmodule
