/*
* Copyright 2024 NXP
* NXP Confidential and Proprietary. This software is owned or controlled by NXP and may only be used strictly in
* accordance with the applicable license terms. By expressly accepting such terms or by downloading, installing,
* activating and/or otherwise using the software, you are agreeing that you have read, and that you agree to
* comply with and are bound by, such license terms.  If you do not agree to be bound by the applicable license
* terms, then you may not retain, install, activate or otherwise use the software.
*/

#include "lvgl.h"
#include <stdio.h>
#include "gui_guider.h"
#include "events_init.h"
#include "widgets_init.h"



void setup_scr_screen(lv_ui *ui)
{
	//Write codes screen
	ui->screen = lv_obj_create(NULL);
	lv_obj_set_size(ui->screen, 800, 480);
	lv_obj_set_scrollbar_mode(ui->screen, LV_SCROLLBAR_MODE_OFF);

	//Write style for screen, Part: LV_PART_MAIN, State: LV_STATE_DEFAULT.
	lv_obj_set_style_bg_opa(ui->screen, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen, lv_color_hex(0x18125C), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen, LV_GRAD_DIR_HOR, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_color(ui->screen, lv_color_hex(0xbcbad0), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_main_stop(ui->screen, 185, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_stop(ui->screen, 255, LV_PART_MAIN|LV_STATE_DEFAULT);

	//Write codes screen_slider_x_pix
	ui->screen_slider_x_pix = lv_slider_create(ui->screen);
	lv_slider_set_range(ui->screen_slider_x_pix, 640, 1920);
	lv_slider_set_mode(ui->screen_slider_x_pix, LV_SLIDER_MODE_NORMAL);
	lv_slider_set_value(ui->screen_slider_x_pix, 640, LV_ANIM_OFF);
	lv_obj_set_pos(ui->screen_slider_x_pix, 50, 330);
	lv_obj_set_size(ui->screen_slider_x_pix, 700, 30);

	//Write style for screen_slider_x_pix, Part: LV_PART_MAIN, State: LV_STATE_DEFAULT.
	lv_obj_set_style_bg_opa(ui->screen_slider_x_pix, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen_slider_x_pix, lv_color_hex(0xffffff), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen_slider_x_pix, LV_GRAD_DIR_NONE, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_slider_x_pix, 50, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_outline_width(ui->screen_slider_x_pix, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_width(ui->screen_slider_x_pix, 0, LV_PART_MAIN|LV_STATE_DEFAULT);

	//Write style for screen_slider_x_pix, Part: LV_PART_INDICATOR, State: LV_STATE_DEFAULT.
	lv_obj_set_style_bg_opa(ui->screen_slider_x_pix, 255, LV_PART_INDICATOR|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen_slider_x_pix, lv_color_hex(0xD4CC89), LV_PART_INDICATOR|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen_slider_x_pix, LV_GRAD_DIR_NONE, LV_PART_INDICATOR|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_slider_x_pix, 50, LV_PART_INDICATOR|LV_STATE_DEFAULT);

	//Write style for screen_slider_x_pix, Part: LV_PART_KNOB, State: LV_STATE_DEFAULT.
	lv_obj_set_style_bg_opa(ui->screen_slider_x_pix, 255, LV_PART_KNOB|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen_slider_x_pix, lv_color_hex(0x00ed5c), LV_PART_KNOB|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen_slider_x_pix, LV_GRAD_DIR_NONE, LV_PART_KNOB|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_slider_x_pix, 50, LV_PART_KNOB|LV_STATE_DEFAULT);

	//Write codes screen_cont_mode_control
	ui->screen_cont_mode_control = lv_obj_create(ui->screen);
	lv_obj_set_pos(ui->screen_cont_mode_control, 20, 109);
	lv_obj_set_size(ui->screen_cont_mode_control, 760, 150);
	lv_obj_set_scrollbar_mode(ui->screen_cont_mode_control, LV_SCROLLBAR_MODE_OFF);

	//Write style for screen_cont_mode_control, Part: LV_PART_MAIN, State: LV_STATE_DEFAULT.
	lv_obj_set_style_border_width(ui->screen_cont_mode_control, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_cont_mode_control, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_opa(ui->screen_cont_mode_control, 141, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen_cont_mode_control, lv_color_hex(0xffffff), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen_cont_mode_control, LV_GRAD_DIR_NONE, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_top(ui->screen_cont_mode_control, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_bottom(ui->screen_cont_mode_control, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_left(ui->screen_cont_mode_control, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_right(ui->screen_cont_mode_control, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_width(ui->screen_cont_mode_control, 0, LV_PART_MAIN|LV_STATE_DEFAULT);

	//Write codes screen_label_1
	ui->screen_label_1 = lv_label_create(ui->screen_cont_mode_control);
	lv_label_set_text(ui->screen_label_1, "模式选择");
	lv_label_set_long_mode(ui->screen_label_1, LV_LABEL_LONG_WRAP);
	lv_obj_set_pos(ui->screen_label_1, 6, 7);
	lv_obj_set_size(ui->screen_label_1, 134, 32);

	//Write style for screen_label_1, Part: LV_PART_MAIN, State: LV_STATE_DEFAULT.
	lv_obj_set_style_border_width(ui->screen_label_1, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_label_1, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_color(ui->screen_label_1, lv_color_hex(0x18125C), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_font(ui->screen_label_1, &lv_font_MI_LanTing_Regular_28, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_opa(ui->screen_label_1, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_letter_space(ui->screen_label_1, 2, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_line_space(ui->screen_label_1, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_align(ui->screen_label_1, LV_TEXT_ALIGN_CENTER, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_opa(ui->screen_label_1, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen_label_1, lv_color_hex(0xD4CC89), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen_label_1, LV_GRAD_DIR_NONE, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_top(ui->screen_label_1, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_right(ui->screen_label_1, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_bottom(ui->screen_label_1, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_left(ui->screen_label_1, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_width(ui->screen_label_1, 0, LV_PART_MAIN|LV_STATE_DEFAULT);

	//Write codes screen_btn_hand_set
	ui->screen_btn_hand_set = lv_btn_create(ui->screen_cont_mode_control);
	ui->screen_btn_hand_set_label = lv_label_create(ui->screen_btn_hand_set);
	lv_label_set_text(ui->screen_btn_hand_set_label, "手动模式");
	lv_label_set_long_mode(ui->screen_btn_hand_set_label, LV_LABEL_LONG_WRAP);
	lv_obj_align(ui->screen_btn_hand_set_label, LV_ALIGN_CENTER, 0, 0);
	lv_obj_set_style_pad_all(ui->screen_btn_hand_set, 0, LV_STATE_DEFAULT);
	lv_obj_set_width(ui->screen_btn_hand_set_label, LV_PCT(100));
	lv_obj_set_pos(ui->screen_btn_hand_set, 65, 40);
	lv_obj_set_size(ui->screen_btn_hand_set, 125, 70);

	//Write style for screen_btn_hand_set, Part: LV_PART_MAIN, State: LV_STATE_DEFAULT.
	lv_obj_set_style_bg_opa(ui->screen_btn_hand_set, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen_btn_hand_set, lv_color_hex(0x18125C), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen_btn_hand_set, LV_GRAD_DIR_NONE, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_width(ui->screen_btn_hand_set, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_btn_hand_set, 5, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_width(ui->screen_btn_hand_set, 5, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_color(ui->screen_btn_hand_set, lv_color_hex(0x000000), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_opa(ui->screen_btn_hand_set, 79, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_spread(ui->screen_btn_hand_set, 5, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_ofs_x(ui->screen_btn_hand_set, -4, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_ofs_y(ui->screen_btn_hand_set, 4, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_color(ui->screen_btn_hand_set, lv_color_hex(0xD4C988), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_font(ui->screen_btn_hand_set, &lv_font_MI_LanTing_Regular_28, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_opa(ui->screen_btn_hand_set, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_align(ui->screen_btn_hand_set, LV_TEXT_ALIGN_CENTER, LV_PART_MAIN|LV_STATE_DEFAULT);

	//Write codes screen_btn_demo_linear
	ui->screen_btn_demo_linear = lv_btn_create(ui->screen_cont_mode_control);
	ui->screen_btn_demo_linear_label = lv_label_create(ui->screen_btn_demo_linear);
	lv_label_set_text(ui->screen_btn_demo_linear_label, "线性缩放动画演示");
	lv_label_set_long_mode(ui->screen_btn_demo_linear_label, LV_LABEL_LONG_WRAP);
	lv_obj_align(ui->screen_btn_demo_linear_label, LV_ALIGN_CENTER, 0, 0);
	lv_obj_set_style_pad_all(ui->screen_btn_demo_linear, 0, LV_STATE_DEFAULT);
	lv_obj_set_width(ui->screen_btn_demo_linear_label, LV_PCT(100));
	lv_obj_set_pos(ui->screen_btn_demo_linear, 450, 15);
	lv_obj_set_size(ui->screen_btn_demo_linear, 263, 50);

	//Write style for screen_btn_demo_linear, Part: LV_PART_MAIN, State: LV_STATE_DEFAULT.
	lv_obj_set_style_bg_opa(ui->screen_btn_demo_linear, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen_btn_demo_linear, lv_color_hex(0x18125C), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen_btn_demo_linear, LV_GRAD_DIR_NONE, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_width(ui->screen_btn_demo_linear, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_btn_demo_linear, 5, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_width(ui->screen_btn_demo_linear, 5, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_color(ui->screen_btn_demo_linear, lv_color_hex(0x000000), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_opa(ui->screen_btn_demo_linear, 79, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_spread(ui->screen_btn_demo_linear, 5, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_ofs_x(ui->screen_btn_demo_linear, -4, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_ofs_y(ui->screen_btn_demo_linear, 4, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_color(ui->screen_btn_demo_linear, lv_color_hex(0xD4C988), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_font(ui->screen_btn_demo_linear, &lv_font_MI_LanTing_Regular_28, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_opa(ui->screen_btn_demo_linear, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_align(ui->screen_btn_demo_linear, LV_TEXT_ALIGN_CENTER, LV_PART_MAIN|LV_STATE_DEFAULT);

	//Write codes screen_btn_demo_nonlinear
	ui->screen_btn_demo_nonlinear = lv_btn_create(ui->screen_cont_mode_control);
	ui->screen_btn_demo_nonlinear_label = lv_label_create(ui->screen_btn_demo_nonlinear);
	lv_label_set_text(ui->screen_btn_demo_nonlinear_label, "非线性缩放动画演示");
	lv_label_set_long_mode(ui->screen_btn_demo_nonlinear_label, LV_LABEL_LONG_WRAP);
	lv_obj_align(ui->screen_btn_demo_nonlinear_label, LV_ALIGN_CENTER, 0, 0);
	lv_obj_set_style_pad_all(ui->screen_btn_demo_nonlinear, 0, LV_STATE_DEFAULT);
	lv_obj_set_width(ui->screen_btn_demo_nonlinear_label, LV_PCT(100));
	lv_obj_set_pos(ui->screen_btn_demo_nonlinear, 450, 85);
	lv_obj_set_size(ui->screen_btn_demo_nonlinear, 265, 50);

	//Write style for screen_btn_demo_nonlinear, Part: LV_PART_MAIN, State: LV_STATE_DEFAULT.
	lv_obj_set_style_bg_opa(ui->screen_btn_demo_nonlinear, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen_btn_demo_nonlinear, lv_color_hex(0x18125C), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen_btn_demo_nonlinear, LV_GRAD_DIR_NONE, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_width(ui->screen_btn_demo_nonlinear, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_btn_demo_nonlinear, 5, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_width(ui->screen_btn_demo_nonlinear, 5, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_color(ui->screen_btn_demo_nonlinear, lv_color_hex(0x000000), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_opa(ui->screen_btn_demo_nonlinear, 79, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_spread(ui->screen_btn_demo_nonlinear, 5, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_ofs_x(ui->screen_btn_demo_nonlinear, -4, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_ofs_y(ui->screen_btn_demo_nonlinear, 4, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_color(ui->screen_btn_demo_nonlinear, lv_color_hex(0xD4C988), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_font(ui->screen_btn_demo_nonlinear, &lv_font_MI_LanTing_Regular_28, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_opa(ui->screen_btn_demo_nonlinear, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_align(ui->screen_btn_demo_nonlinear, LV_TEXT_ALIGN_CENTER, LV_PART_MAIN|LV_STATE_DEFAULT);

	//Write codes screen_cont_1
	ui->screen_cont_1 = lv_obj_create(ui->screen_cont_mode_control);
	lv_obj_set_pos(ui->screen_cont_1, 235, 25);
	lv_obj_set_size(ui->screen_cont_1, 170, 100);
	lv_obj_set_scrollbar_mode(ui->screen_cont_1, LV_SCROLLBAR_MODE_OFF);

	//Write style for screen_cont_1, Part: LV_PART_MAIN, State: LV_STATE_DEFAULT.
	lv_obj_set_style_border_width(ui->screen_cont_1, 2, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_opa(ui->screen_cont_1, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_color(ui->screen_cont_1, lv_color_hex(0xD4CC89), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_side(ui->screen_cont_1, LV_BORDER_SIDE_FULL, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_cont_1, 2, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_opa(ui->screen_cont_1, 166, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen_cont_1, lv_color_hex(0xe1dcae), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen_cont_1, LV_GRAD_DIR_NONE, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_top(ui->screen_cont_1, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_bottom(ui->screen_cont_1, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_left(ui->screen_cont_1, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_right(ui->screen_cont_1, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_width(ui->screen_cont_1, 5, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_color(ui->screen_cont_1, lv_color_hex(0x000000), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_opa(ui->screen_cont_1, 77, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_spread(ui->screen_cont_1, 5, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_ofs_x(ui->screen_cont_1, -4, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_ofs_y(ui->screen_cont_1, 4, LV_PART_MAIN|LV_STATE_DEFAULT);

	//Write codes screen_ddlist_nonlinear
	ui->screen_ddlist_nonlinear = lv_dropdown_create(ui->screen_cont_1);
	lv_dropdown_set_options(ui->screen_ddlist_nonlinear, "Bounce\nCirc\nQuint");
	lv_obj_set_pos(ui->screen_ddlist_nonlinear, 17, 40);
	lv_obj_set_size(ui->screen_ddlist_nonlinear, 130, 46);

	//Write style for screen_ddlist_nonlinear, Part: LV_PART_MAIN, State: LV_STATE_DEFAULT.
	lv_obj_set_style_border_width(ui->screen_ddlist_nonlinear, 2, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_opa(ui->screen_ddlist_nonlinear, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_color(ui->screen_ddlist_nonlinear, lv_color_hex(0x18125C), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_side(ui->screen_ddlist_nonlinear, LV_BORDER_SIDE_FULL, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_ddlist_nonlinear, 3, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_color(ui->screen_ddlist_nonlinear, lv_color_hex(0x0D3055), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_font(ui->screen_ddlist_nonlinear, &lv_font_MI_LanTing_Regular_24, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_opa(ui->screen_ddlist_nonlinear, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_opa(ui->screen_ddlist_nonlinear, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen_ddlist_nonlinear, lv_color_hex(0xD4CC89), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen_ddlist_nonlinear, LV_GRAD_DIR_NONE, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_top(ui->screen_ddlist_nonlinear, 8, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_right(ui->screen_ddlist_nonlinear, 6, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_left(ui->screen_ddlist_nonlinear, 6, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_width(ui->screen_ddlist_nonlinear, 0, LV_PART_MAIN|LV_STATE_DEFAULT);

	//Write style state: LV_STATE_CHECKED for &style_screen_ddlist_nonlinear_extra_list_selected_checked
	static lv_style_t style_screen_ddlist_nonlinear_extra_list_selected_checked;
	ui_init_style(&style_screen_ddlist_nonlinear_extra_list_selected_checked);
	
	lv_style_set_border_width(&style_screen_ddlist_nonlinear_extra_list_selected_checked, 1);
	lv_style_set_border_opa(&style_screen_ddlist_nonlinear_extra_list_selected_checked, 255);
	lv_style_set_border_color(&style_screen_ddlist_nonlinear_extra_list_selected_checked, lv_color_hex(0xe1e6ee));
	lv_style_set_border_side(&style_screen_ddlist_nonlinear_extra_list_selected_checked, LV_BORDER_SIDE_FULL);
	lv_style_set_radius(&style_screen_ddlist_nonlinear_extra_list_selected_checked, 3);
	lv_style_set_bg_opa(&style_screen_ddlist_nonlinear_extra_list_selected_checked, 255);
	lv_style_set_bg_color(&style_screen_ddlist_nonlinear_extra_list_selected_checked, lv_color_hex(0x00a1b5));
	lv_style_set_bg_grad_dir(&style_screen_ddlist_nonlinear_extra_list_selected_checked, LV_GRAD_DIR_NONE);
	lv_obj_add_style(lv_dropdown_get_list(ui->screen_ddlist_nonlinear), &style_screen_ddlist_nonlinear_extra_list_selected_checked, LV_PART_SELECTED|LV_STATE_CHECKED);

	//Write style state: LV_STATE_DEFAULT for &style_screen_ddlist_nonlinear_extra_list_main_default
	static lv_style_t style_screen_ddlist_nonlinear_extra_list_main_default;
	ui_init_style(&style_screen_ddlist_nonlinear_extra_list_main_default);
	
	lv_style_set_max_height(&style_screen_ddlist_nonlinear_extra_list_main_default, 90);
	lv_style_set_text_color(&style_screen_ddlist_nonlinear_extra_list_main_default, lv_color_hex(0x0D3055));
	lv_style_set_text_font(&style_screen_ddlist_nonlinear_extra_list_main_default, &lv_font_MI_LanTing_Regular_12);
	lv_style_set_text_opa(&style_screen_ddlist_nonlinear_extra_list_main_default, 255);
	lv_style_set_border_width(&style_screen_ddlist_nonlinear_extra_list_main_default, 1);
	lv_style_set_border_opa(&style_screen_ddlist_nonlinear_extra_list_main_default, 255);
	lv_style_set_border_color(&style_screen_ddlist_nonlinear_extra_list_main_default, lv_color_hex(0xe1e6ee));
	lv_style_set_border_side(&style_screen_ddlist_nonlinear_extra_list_main_default, LV_BORDER_SIDE_FULL);
	lv_style_set_radius(&style_screen_ddlist_nonlinear_extra_list_main_default, 3);
	lv_style_set_bg_opa(&style_screen_ddlist_nonlinear_extra_list_main_default, 255);
	lv_style_set_bg_color(&style_screen_ddlist_nonlinear_extra_list_main_default, lv_color_hex(0xffffff));
	lv_style_set_bg_grad_dir(&style_screen_ddlist_nonlinear_extra_list_main_default, LV_GRAD_DIR_NONE);
	lv_obj_add_style(lv_dropdown_get_list(ui->screen_ddlist_nonlinear), &style_screen_ddlist_nonlinear_extra_list_main_default, LV_PART_MAIN|LV_STATE_DEFAULT);

	//Write style state: LV_STATE_DEFAULT for &style_screen_ddlist_nonlinear_extra_list_scrollbar_default
	static lv_style_t style_screen_ddlist_nonlinear_extra_list_scrollbar_default;
	ui_init_style(&style_screen_ddlist_nonlinear_extra_list_scrollbar_default);
	
	lv_style_set_radius(&style_screen_ddlist_nonlinear_extra_list_scrollbar_default, 3);
	lv_style_set_bg_opa(&style_screen_ddlist_nonlinear_extra_list_scrollbar_default, 255);
	lv_style_set_bg_color(&style_screen_ddlist_nonlinear_extra_list_scrollbar_default, lv_color_hex(0x00ff00));
	lv_style_set_bg_grad_dir(&style_screen_ddlist_nonlinear_extra_list_scrollbar_default, LV_GRAD_DIR_NONE);
	lv_obj_add_style(lv_dropdown_get_list(ui->screen_ddlist_nonlinear), &style_screen_ddlist_nonlinear_extra_list_scrollbar_default, LV_PART_SCROLLBAR|LV_STATE_DEFAULT);

	//Write codes screen_label_2
	ui->screen_label_2 = lv_label_create(ui->screen_cont_1);
	lv_label_set_text(ui->screen_label_2, "非线性动画类型");
	lv_label_set_long_mode(ui->screen_label_2, LV_LABEL_LONG_WRAP);
	lv_obj_set_pos(ui->screen_label_2, 12, 11);
	lv_obj_set_size(ui->screen_label_2, 140, 18);

	//Write style for screen_label_2, Part: LV_PART_MAIN, State: LV_STATE_DEFAULT.
	lv_obj_set_style_bg_opa(ui->screen_label_2, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_width(ui->screen_label_2, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_width(ui->screen_label_2, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_label_2, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_color(ui->screen_label_2, lv_color_hex(0x18125C), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_font(ui->screen_label_2, &lv_font_MI_LanTing_Regular_18, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_opa(ui->screen_label_2, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_letter_space(ui->screen_label_2, 2, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_line_space(ui->screen_label_2, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_align(ui->screen_label_2, LV_TEXT_ALIGN_CENTER, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_top(ui->screen_label_2, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_right(ui->screen_label_2, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_bottom(ui->screen_label_2, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_left(ui->screen_label_2, 0, LV_PART_MAIN|LV_STATE_DEFAULT);

	//Write codes screen_btn_select
	ui->screen_btn_select = lv_btn_create(ui->screen_cont_mode_control);
	ui->screen_btn_select_label = lv_label_create(ui->screen_btn_select);
	lv_label_set_text(ui->screen_btn_select_label, "");
	lv_label_set_long_mode(ui->screen_btn_select_label, LV_LABEL_LONG_WRAP);
	lv_obj_align(ui->screen_btn_select_label, LV_ALIGN_CENTER, 0, 0);
	lv_obj_set_style_pad_all(ui->screen_btn_select, 0, LV_STATE_DEFAULT);
	lv_obj_set_width(ui->screen_btn_select_label, LV_PCT(100));
	lv_obj_set_pos(ui->screen_btn_select, 65, 40);
	lv_obj_set_size(ui->screen_btn_select, 125, 70);

	//Write style for screen_btn_select, Part: LV_PART_MAIN, State: LV_STATE_DEFAULT.
	lv_obj_set_style_bg_opa(ui->screen_btn_select, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_width(ui->screen_btn_select, 6, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_opa(ui->screen_btn_select, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_color(ui->screen_btn_select, lv_color_hex(0xD4CC89), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_side(ui->screen_btn_select, LV_BORDER_SIDE_FULL, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_btn_select, 5, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_width(ui->screen_btn_select, 5, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_color(ui->screen_btn_select, lv_color_hex(0x000000), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_opa(ui->screen_btn_select, 79, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_spread(ui->screen_btn_select, 5, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_ofs_x(ui->screen_btn_select, -4, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_ofs_y(ui->screen_btn_select, 4, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_color(ui->screen_btn_select, lv_color_hex(0xD4C988), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_font(ui->screen_btn_select, &lv_font_MI_LanTing_Regular_28, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_opa(ui->screen_btn_select, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_align(ui->screen_btn_select, LV_TEXT_ALIGN_CENTER, LV_PART_MAIN|LV_STATE_DEFAULT);

	//Write codes screen_label_x_pix_
	ui->screen_label_x_pix_ = lv_label_create(ui->screen);
	lv_label_set_text(ui->screen_label_x_pix_, "水平像素数：");
	lv_label_set_long_mode(ui->screen_label_x_pix_, LV_LABEL_LONG_WRAP);
	lv_obj_set_pos(ui->screen_label_x_pix_, 50, 270);
	lv_obj_set_size(ui->screen_label_x_pix_, 173, 32);

	//Write style for screen_label_x_pix_, Part: LV_PART_MAIN, State: LV_STATE_DEFAULT.
	lv_obj_set_style_border_width(ui->screen_label_x_pix_, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_label_x_pix_, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_color(ui->screen_label_x_pix_, lv_color_hex(0x18125C), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_font(ui->screen_label_x_pix_, &lv_font_MI_LanTing_Regular_28, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_opa(ui->screen_label_x_pix_, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_letter_space(ui->screen_label_x_pix_, 2, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_line_space(ui->screen_label_x_pix_, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_align(ui->screen_label_x_pix_, LV_TEXT_ALIGN_CENTER, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_opa(ui->screen_label_x_pix_, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen_label_x_pix_, lv_color_hex(0xD4CC89), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen_label_x_pix_, LV_GRAD_DIR_NONE, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_top(ui->screen_label_x_pix_, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_right(ui->screen_label_x_pix_, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_bottom(ui->screen_label_x_pix_, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_left(ui->screen_label_x_pix_, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_width(ui->screen_label_x_pix_, 0, LV_PART_MAIN|LV_STATE_DEFAULT);

	//Write codes screen_label_y_pix_len_
	ui->screen_label_y_pix_len_ = lv_label_create(ui->screen);
	lv_label_set_text(ui->screen_label_y_pix_len_, "垂直像素数：");
	lv_label_set_long_mode(ui->screen_label_y_pix_len_, LV_LABEL_LONG_WRAP);
	lv_obj_set_pos(ui->screen_label_y_pix_len_, 50, 375);
	lv_obj_set_size(ui->screen_label_y_pix_len_, 173, 32);

	//Write style for screen_label_y_pix_len_, Part: LV_PART_MAIN, State: LV_STATE_DEFAULT.
	lv_obj_set_style_border_width(ui->screen_label_y_pix_len_, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_label_y_pix_len_, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_color(ui->screen_label_y_pix_len_, lv_color_hex(0x18125C), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_font(ui->screen_label_y_pix_len_, &lv_font_MI_LanTing_Regular_28, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_opa(ui->screen_label_y_pix_len_, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_letter_space(ui->screen_label_y_pix_len_, 2, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_line_space(ui->screen_label_y_pix_len_, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_align(ui->screen_label_y_pix_len_, LV_TEXT_ALIGN_CENTER, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_opa(ui->screen_label_y_pix_len_, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen_label_y_pix_len_, lv_color_hex(0xD4CC89), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen_label_y_pix_len_, LV_GRAD_DIR_NONE, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_top(ui->screen_label_y_pix_len_, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_right(ui->screen_label_y_pix_len_, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_bottom(ui->screen_label_y_pix_len_, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_left(ui->screen_label_y_pix_len_, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_width(ui->screen_label_y_pix_len_, 0, LV_PART_MAIN|LV_STATE_DEFAULT);

	//Write codes screen_label_y_pix
	ui->screen_label_y_pix = lv_label_create(ui->screen);
	lv_label_set_text(ui->screen_label_y_pix, "480");
	lv_label_set_long_mode(ui->screen_label_y_pix, LV_LABEL_LONG_WRAP);
	lv_obj_set_pos(ui->screen_label_y_pix, 230, 375);
	lv_obj_set_size(ui->screen_label_y_pix, 80, 32);

	//Write style for screen_label_y_pix, Part: LV_PART_MAIN, State: LV_STATE_DEFAULT.
	lv_obj_set_style_border_width(ui->screen_label_y_pix, 2, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_opa(ui->screen_label_y_pix, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_color(ui->screen_label_y_pix, lv_color_hex(0x18125C), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_side(ui->screen_label_y_pix, LV_BORDER_SIDE_FULL, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_label_y_pix, 2, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_color(ui->screen_label_y_pix, lv_color_hex(0x18125C), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_font(ui->screen_label_y_pix, &lv_font_MI_LanTing_Regular_28, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_opa(ui->screen_label_y_pix, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_letter_space(ui->screen_label_y_pix, 1, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_line_space(ui->screen_label_y_pix, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_align(ui->screen_label_y_pix, LV_TEXT_ALIGN_CENTER, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_opa(ui->screen_label_y_pix, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen_label_y_pix, lv_color_hex(0xffffff), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen_label_y_pix, LV_GRAD_DIR_NONE, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_top(ui->screen_label_y_pix, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_right(ui->screen_label_y_pix, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_bottom(ui->screen_label_y_pix, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_left(ui->screen_label_y_pix, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_width(ui->screen_label_y_pix, 0, LV_PART_MAIN|LV_STATE_DEFAULT);

	//Write codes screen_label_x_pix
	ui->screen_label_x_pix = lv_label_create(ui->screen);
	lv_label_set_text(ui->screen_label_x_pix, "640");
	lv_label_set_long_mode(ui->screen_label_x_pix, LV_LABEL_LONG_WRAP);
	lv_obj_set_pos(ui->screen_label_x_pix, 230, 270);
	lv_obj_set_size(ui->screen_label_x_pix, 80, 32);

	//Write style for screen_label_x_pix, Part: LV_PART_MAIN, State: LV_STATE_DEFAULT.
	lv_obj_set_style_border_width(ui->screen_label_x_pix, 2, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_opa(ui->screen_label_x_pix, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_color(ui->screen_label_x_pix, lv_color_hex(0x18125C), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_side(ui->screen_label_x_pix, LV_BORDER_SIDE_FULL, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_label_x_pix, 2, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_color(ui->screen_label_x_pix, lv_color_hex(0x18125C), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_font(ui->screen_label_x_pix, &lv_font_MI_LanTing_Regular_28, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_opa(ui->screen_label_x_pix, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_letter_space(ui->screen_label_x_pix, 1, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_line_space(ui->screen_label_x_pix, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_align(ui->screen_label_x_pix, LV_TEXT_ALIGN_CENTER, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_opa(ui->screen_label_x_pix, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen_label_x_pix, lv_color_hex(0xffffff), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen_label_x_pix, LV_GRAD_DIR_NONE, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_top(ui->screen_label_x_pix, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_right(ui->screen_label_x_pix, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_bottom(ui->screen_label_x_pix, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_left(ui->screen_label_x_pix, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_width(ui->screen_label_x_pix, 0, LV_PART_MAIN|LV_STATE_DEFAULT);

	//Write codes screen_img_1
	ui->screen_img_1 = lv_img_create(ui->screen);
	lv_obj_add_flag(ui->screen_img_1, LV_OBJ_FLAG_CLICKABLE);
	lv_img_set_src(ui->screen_img_1, &_cbf040c3eda1f28470a3ec0f5384e18e1334bea0_alpha_242x106);
	lv_img_set_pivot(ui->screen_img_1, 50,50);
	lv_img_set_angle(ui->screen_img_1, 0);
	lv_obj_set_pos(ui->screen_img_1, 279, 0);
	lv_obj_set_size(ui->screen_img_1, 242, 106);

	//Write style for screen_img_1, Part: LV_PART_MAIN, State: LV_STATE_DEFAULT.
	lv_obj_set_style_img_opa(ui->screen_img_1, 255, LV_PART_MAIN|LV_STATE_DEFAULT);

	//Write codes screen_ddlist_min
	ui->screen_ddlist_min = lv_dropdown_create(ui->screen);
	lv_dropdown_set_options(ui->screen_ddlist_min, "   640\n   320\n   160");
	lv_obj_set_pos(ui->screen_ddlist_min, 690, 25);
	lv_obj_set_size(ui->screen_ddlist_min, 90, 36);

	//Write style for screen_ddlist_min, Part: LV_PART_MAIN, State: LV_STATE_DEFAULT.
	lv_obj_set_style_text_color(ui->screen_ddlist_min, lv_color_hex(0x0D3055), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_font(ui->screen_ddlist_min, &lv_font_MI_LanTing_Regular_18, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_opa(ui->screen_ddlist_min, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_width(ui->screen_ddlist_min, 2, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_opa(ui->screen_ddlist_min, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_color(ui->screen_ddlist_min, lv_color_hex(0x706d9a), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_side(ui->screen_ddlist_min, LV_BORDER_SIDE_FULL, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_top(ui->screen_ddlist_min, 8, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_left(ui->screen_ddlist_min, 6, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_right(ui->screen_ddlist_min, 6, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_ddlist_min, 3, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_opa(ui->screen_ddlist_min, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen_ddlist_min, lv_color_hex(0xD4CC89), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen_ddlist_min, LV_GRAD_DIR_NONE, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_width(ui->screen_ddlist_min, 0, LV_PART_MAIN|LV_STATE_DEFAULT);

	//Write style state: LV_STATE_CHECKED for &style_screen_ddlist_min_extra_list_selected_checked
	static lv_style_t style_screen_ddlist_min_extra_list_selected_checked;
	ui_init_style(&style_screen_ddlist_min_extra_list_selected_checked);
	
	lv_style_set_border_width(&style_screen_ddlist_min_extra_list_selected_checked, 1);
	lv_style_set_border_opa(&style_screen_ddlist_min_extra_list_selected_checked, 255);
	lv_style_set_border_color(&style_screen_ddlist_min_extra_list_selected_checked, lv_color_hex(0xe1e6ee));
	lv_style_set_border_side(&style_screen_ddlist_min_extra_list_selected_checked, LV_BORDER_SIDE_FULL);
	lv_style_set_radius(&style_screen_ddlist_min_extra_list_selected_checked, 3);
	lv_style_set_bg_opa(&style_screen_ddlist_min_extra_list_selected_checked, 255);
	lv_style_set_bg_color(&style_screen_ddlist_min_extra_list_selected_checked, lv_color_hex(0x00a1b5));
	lv_style_set_bg_grad_dir(&style_screen_ddlist_min_extra_list_selected_checked, LV_GRAD_DIR_NONE);
	lv_obj_add_style(lv_dropdown_get_list(ui->screen_ddlist_min), &style_screen_ddlist_min_extra_list_selected_checked, LV_PART_SELECTED|LV_STATE_CHECKED);

	//Write style state: LV_STATE_DEFAULT for &style_screen_ddlist_min_extra_list_main_default
	static lv_style_t style_screen_ddlist_min_extra_list_main_default;
	ui_init_style(&style_screen_ddlist_min_extra_list_main_default);
	
	lv_style_set_max_height(&style_screen_ddlist_min_extra_list_main_default, 90);
	lv_style_set_text_color(&style_screen_ddlist_min_extra_list_main_default, lv_color_hex(0x0D3055));
	lv_style_set_text_font(&style_screen_ddlist_min_extra_list_main_default, &lv_font_MI_LanTing_Regular_12);
	lv_style_set_text_opa(&style_screen_ddlist_min_extra_list_main_default, 255);
	lv_style_set_border_width(&style_screen_ddlist_min_extra_list_main_default, 1);
	lv_style_set_border_opa(&style_screen_ddlist_min_extra_list_main_default, 255);
	lv_style_set_border_color(&style_screen_ddlist_min_extra_list_main_default, lv_color_hex(0xe1e6ee));
	lv_style_set_border_side(&style_screen_ddlist_min_extra_list_main_default, LV_BORDER_SIDE_FULL);
	lv_style_set_radius(&style_screen_ddlist_min_extra_list_main_default, 3);
	lv_style_set_bg_opa(&style_screen_ddlist_min_extra_list_main_default, 255);
	lv_style_set_bg_color(&style_screen_ddlist_min_extra_list_main_default, lv_color_hex(0xffffff));
	lv_style_set_bg_grad_dir(&style_screen_ddlist_min_extra_list_main_default, LV_GRAD_DIR_NONE);
	lv_obj_add_style(lv_dropdown_get_list(ui->screen_ddlist_min), &style_screen_ddlist_min_extra_list_main_default, LV_PART_MAIN|LV_STATE_DEFAULT);

	//Write style state: LV_STATE_DEFAULT for &style_screen_ddlist_min_extra_list_scrollbar_default
	static lv_style_t style_screen_ddlist_min_extra_list_scrollbar_default;
	ui_init_style(&style_screen_ddlist_min_extra_list_scrollbar_default);
	
	lv_style_set_radius(&style_screen_ddlist_min_extra_list_scrollbar_default, 3);
	lv_style_set_bg_opa(&style_screen_ddlist_min_extra_list_scrollbar_default, 255);
	lv_style_set_bg_color(&style_screen_ddlist_min_extra_list_scrollbar_default, lv_color_hex(0x00ff00));
	lv_style_set_bg_grad_dir(&style_screen_ddlist_min_extra_list_scrollbar_default, LV_GRAD_DIR_NONE);
	lv_obj_add_style(lv_dropdown_get_list(ui->screen_ddlist_min), &style_screen_ddlist_min_extra_list_scrollbar_default, LV_PART_SCROLLBAR|LV_STATE_DEFAULT);

	//Write codes screen_ddlist_max
	ui->screen_ddlist_max = lv_dropdown_create(ui->screen);
	lv_dropdown_set_options(ui->screen_ddlist_max, " 1920");
	lv_obj_set_pos(ui->screen_ddlist_max, 563, 25);
	lv_obj_set_size(ui->screen_ddlist_max, 90, 36);

	//Write style for screen_ddlist_max, Part: LV_PART_MAIN, State: LV_STATE_DEFAULT.
	lv_obj_set_style_text_color(ui->screen_ddlist_max, lv_color_hex(0x0D3055), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_font(ui->screen_ddlist_max, &lv_font_MI_LanTing_Regular_18, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_opa(ui->screen_ddlist_max, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_width(ui->screen_ddlist_max, 2, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_opa(ui->screen_ddlist_max, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_color(ui->screen_ddlist_max, lv_color_hex(0x18125C), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_side(ui->screen_ddlist_max, LV_BORDER_SIDE_FULL, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_top(ui->screen_ddlist_max, 8, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_left(ui->screen_ddlist_max, 6, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_right(ui->screen_ddlist_max, 6, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_ddlist_max, 3, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_opa(ui->screen_ddlist_max, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen_ddlist_max, lv_color_hex(0xD4CC89), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen_ddlist_max, LV_GRAD_DIR_NONE, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_width(ui->screen_ddlist_max, 0, LV_PART_MAIN|LV_STATE_DEFAULT);

	//Write style state: LV_STATE_CHECKED for &style_screen_ddlist_max_extra_list_selected_checked
	static lv_style_t style_screen_ddlist_max_extra_list_selected_checked;
	ui_init_style(&style_screen_ddlist_max_extra_list_selected_checked);
	
	lv_style_set_border_width(&style_screen_ddlist_max_extra_list_selected_checked, 1);
	lv_style_set_border_opa(&style_screen_ddlist_max_extra_list_selected_checked, 255);
	lv_style_set_border_color(&style_screen_ddlist_max_extra_list_selected_checked, lv_color_hex(0xe1e6ee));
	lv_style_set_border_side(&style_screen_ddlist_max_extra_list_selected_checked, LV_BORDER_SIDE_FULL);
	lv_style_set_radius(&style_screen_ddlist_max_extra_list_selected_checked, 3);
	lv_style_set_bg_opa(&style_screen_ddlist_max_extra_list_selected_checked, 255);
	lv_style_set_bg_color(&style_screen_ddlist_max_extra_list_selected_checked, lv_color_hex(0x00a1b5));
	lv_style_set_bg_grad_dir(&style_screen_ddlist_max_extra_list_selected_checked, LV_GRAD_DIR_NONE);
	lv_obj_add_style(lv_dropdown_get_list(ui->screen_ddlist_max), &style_screen_ddlist_max_extra_list_selected_checked, LV_PART_SELECTED|LV_STATE_CHECKED);

	//Write style state: LV_STATE_DEFAULT for &style_screen_ddlist_max_extra_list_main_default
	static lv_style_t style_screen_ddlist_max_extra_list_main_default;
	ui_init_style(&style_screen_ddlist_max_extra_list_main_default);
	
	lv_style_set_max_height(&style_screen_ddlist_max_extra_list_main_default, 90);
	lv_style_set_text_color(&style_screen_ddlist_max_extra_list_main_default, lv_color_hex(0x0D3055));
	lv_style_set_text_font(&style_screen_ddlist_max_extra_list_main_default, &lv_font_MI_LanTing_Regular_12);
	lv_style_set_text_opa(&style_screen_ddlist_max_extra_list_main_default, 255);
	lv_style_set_border_width(&style_screen_ddlist_max_extra_list_main_default, 1);
	lv_style_set_border_opa(&style_screen_ddlist_max_extra_list_main_default, 255);
	lv_style_set_border_color(&style_screen_ddlist_max_extra_list_main_default, lv_color_hex(0xe1e6ee));
	lv_style_set_border_side(&style_screen_ddlist_max_extra_list_main_default, LV_BORDER_SIDE_FULL);
	lv_style_set_radius(&style_screen_ddlist_max_extra_list_main_default, 3);
	lv_style_set_bg_opa(&style_screen_ddlist_max_extra_list_main_default, 255);
	lv_style_set_bg_color(&style_screen_ddlist_max_extra_list_main_default, lv_color_hex(0xffffff));
	lv_style_set_bg_grad_dir(&style_screen_ddlist_max_extra_list_main_default, LV_GRAD_DIR_NONE);
	lv_obj_add_style(lv_dropdown_get_list(ui->screen_ddlist_max), &style_screen_ddlist_max_extra_list_main_default, LV_PART_MAIN|LV_STATE_DEFAULT);

	//Write style state: LV_STATE_DEFAULT for &style_screen_ddlist_max_extra_list_scrollbar_default
	static lv_style_t style_screen_ddlist_max_extra_list_scrollbar_default;
	ui_init_style(&style_screen_ddlist_max_extra_list_scrollbar_default);
	
	lv_style_set_radius(&style_screen_ddlist_max_extra_list_scrollbar_default, 3);
	lv_style_set_bg_opa(&style_screen_ddlist_max_extra_list_scrollbar_default, 255);
	lv_style_set_bg_color(&style_screen_ddlist_max_extra_list_scrollbar_default, lv_color_hex(0x00ff00));
	lv_style_set_bg_grad_dir(&style_screen_ddlist_max_extra_list_scrollbar_default, LV_GRAD_DIR_NONE);
	lv_obj_add_style(lv_dropdown_get_list(ui->screen_ddlist_max), &style_screen_ddlist_max_extra_list_scrollbar_default, LV_PART_SCROLLBAR|LV_STATE_DEFAULT);

	//Write codes screen_label_3
	ui->screen_label_3 = lv_label_create(ui->screen);
	lv_label_set_text(ui->screen_label_3, "最大宽度");
	lv_label_set_long_mode(ui->screen_label_3, LV_LABEL_LONG_WRAP);
	lv_obj_set_pos(ui->screen_label_3, 563, 61);
	lv_obj_set_size(ui->screen_label_3, 90, 20);

	//Write style for screen_label_3, Part: LV_PART_MAIN, State: LV_STATE_DEFAULT.
	lv_obj_set_style_border_width(ui->screen_label_3, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_label_3, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_color(ui->screen_label_3, lv_color_hex(0x18125C), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_font(ui->screen_label_3, &lv_font_MI_LanTing_Regular_18, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_opa(ui->screen_label_3, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_letter_space(ui->screen_label_3, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_line_space(ui->screen_label_3, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_align(ui->screen_label_3, LV_TEXT_ALIGN_CENTER, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_opa(ui->screen_label_3, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen_label_3, lv_color_hex(0xD4CC89), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen_label_3, LV_GRAD_DIR_NONE, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_top(ui->screen_label_3, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_right(ui->screen_label_3, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_bottom(ui->screen_label_3, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_left(ui->screen_label_3, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_width(ui->screen_label_3, 0, LV_PART_MAIN|LV_STATE_DEFAULT);

	//Write codes screen_label_4
	ui->screen_label_4 = lv_label_create(ui->screen);
	lv_label_set_text(ui->screen_label_4, "最小宽度");
	lv_label_set_long_mode(ui->screen_label_4, LV_LABEL_LONG_WRAP);
	lv_obj_set_pos(ui->screen_label_4, 690, 61);
	lv_obj_set_size(ui->screen_label_4, 90, 20);

	//Write style for screen_label_4, Part: LV_PART_MAIN, State: LV_STATE_DEFAULT.
	lv_obj_set_style_border_width(ui->screen_label_4, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_label_4, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_color(ui->screen_label_4, lv_color_hex(0x18125C), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_font(ui->screen_label_4, &lv_font_MI_LanTing_Regular_18, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_opa(ui->screen_label_4, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_letter_space(ui->screen_label_4, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_line_space(ui->screen_label_4, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_align(ui->screen_label_4, LV_TEXT_ALIGN_CENTER, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_opa(ui->screen_label_4, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen_label_4, lv_color_hex(0xD4CC89), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen_label_4, LV_GRAD_DIR_NONE, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_top(ui->screen_label_4, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_right(ui->screen_label_4, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_bottom(ui->screen_label_4, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_left(ui->screen_label_4, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_width(ui->screen_label_4, 0, LV_PART_MAIN|LV_STATE_DEFAULT);

	//Write codes screen_slider_y_pix
	ui->screen_slider_y_pix = lv_slider_create(ui->screen);
	lv_slider_set_range(ui->screen_slider_y_pix, 480, 1080);
	lv_slider_set_mode(ui->screen_slider_y_pix, LV_SLIDER_MODE_NORMAL);
	lv_slider_set_value(ui->screen_slider_y_pix, 480, LV_ANIM_OFF);
	lv_obj_set_pos(ui->screen_slider_y_pix, 50, 435);
	lv_obj_set_size(ui->screen_slider_y_pix, 700, 30);

	//Write style for screen_slider_y_pix, Part: LV_PART_MAIN, State: LV_STATE_DEFAULT.
	lv_obj_set_style_bg_opa(ui->screen_slider_y_pix, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen_slider_y_pix, lv_color_hex(0xffffff), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen_slider_y_pix, LV_GRAD_DIR_NONE, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_slider_y_pix, 50, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_outline_width(ui->screen_slider_y_pix, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_width(ui->screen_slider_y_pix, 0, LV_PART_MAIN|LV_STATE_DEFAULT);

	//Write style for screen_slider_y_pix, Part: LV_PART_INDICATOR, State: LV_STATE_DEFAULT.
	lv_obj_set_style_bg_opa(ui->screen_slider_y_pix, 255, LV_PART_INDICATOR|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen_slider_y_pix, lv_color_hex(0xD4CC89), LV_PART_INDICATOR|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen_slider_y_pix, LV_GRAD_DIR_NONE, LV_PART_INDICATOR|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_slider_y_pix, 50, LV_PART_INDICATOR|LV_STATE_DEFAULT);

	//Write style for screen_slider_y_pix, Part: LV_PART_KNOB, State: LV_STATE_DEFAULT.
	lv_obj_set_style_bg_opa(ui->screen_slider_y_pix, 255, LV_PART_KNOB|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen_slider_y_pix, lv_color_hex(0x00ed5c), LV_PART_KNOB|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen_slider_y_pix, LV_GRAD_DIR_NONE, LV_PART_KNOB|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_slider_y_pix, 50, LV_PART_KNOB|LV_STATE_DEFAULT);

	//Write codes screen_btnm_x_pic
	ui->screen_btnm_x_pic = lv_btnmatrix_create(ui->screen);
	static const char *screen_btnm_x_pic_text_map[] = {"-", "+", "",};
	lv_btnmatrix_set_map(ui->screen_btnm_x_pic, screen_btnm_x_pic_text_map);
	lv_obj_set_pos(ui->screen_btnm_x_pic, 345, 265);
	lv_obj_set_size(ui->screen_btnm_x_pic, 358, 55);

	//Write style for screen_btnm_x_pic, Part: LV_PART_MAIN, State: LV_STATE_DEFAULT.
	lv_obj_set_style_border_width(ui->screen_btnm_x_pic, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_top(ui->screen_btnm_x_pic, 4, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_bottom(ui->screen_btnm_x_pic, 4, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_left(ui->screen_btnm_x_pic, 20, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_right(ui->screen_btnm_x_pic, 20, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_row(ui->screen_btnm_x_pic, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_column(ui->screen_btnm_x_pic, 25, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_btnm_x_pic, 5, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_opa(ui->screen_btnm_x_pic, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen_btnm_x_pic, lv_color_hex(0xD4CC89), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen_btnm_x_pic, LV_GRAD_DIR_NONE, LV_PART_MAIN|LV_STATE_DEFAULT);

	//Write style for screen_btnm_x_pic, Part: LV_PART_ITEMS, State: LV_STATE_DEFAULT.
	lv_obj_set_style_border_width(ui->screen_btnm_x_pic, 1, LV_PART_ITEMS|LV_STATE_DEFAULT);
	lv_obj_set_style_border_opa(ui->screen_btnm_x_pic, 255, LV_PART_ITEMS|LV_STATE_DEFAULT);
	lv_obj_set_style_border_color(ui->screen_btnm_x_pic, lv_color_hex(0xc9c9c9), LV_PART_ITEMS|LV_STATE_DEFAULT);
	lv_obj_set_style_border_side(ui->screen_btnm_x_pic, LV_BORDER_SIDE_FULL, LV_PART_ITEMS|LV_STATE_DEFAULT);
	lv_obj_set_style_text_color(ui->screen_btnm_x_pic, lv_color_hex(0xD4C988), LV_PART_ITEMS|LV_STATE_DEFAULT);
	lv_obj_set_style_text_font(ui->screen_btnm_x_pic, &lv_font_MI_LanTing_Regular_28, LV_PART_ITEMS|LV_STATE_DEFAULT);
	lv_obj_set_style_text_opa(ui->screen_btnm_x_pic, 255, LV_PART_ITEMS|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_btnm_x_pic, 4, LV_PART_ITEMS|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_opa(ui->screen_btnm_x_pic, 255, LV_PART_ITEMS|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen_btnm_x_pic, lv_color_hex(0x18125C), LV_PART_ITEMS|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen_btnm_x_pic, LV_GRAD_DIR_NONE, LV_PART_ITEMS|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_width(ui->screen_btnm_x_pic, 0, LV_PART_ITEMS|LV_STATE_DEFAULT);

	//Write codes screen_btnm_y_pic
	ui->screen_btnm_y_pic = lv_btnmatrix_create(ui->screen);
	static const char *screen_btnm_y_pic_text_map[] = {"-", "+", "",};
	lv_btnmatrix_set_map(ui->screen_btnm_y_pic, screen_btnm_y_pic_text_map);
	lv_obj_set_pos(ui->screen_btnm_y_pic, 345, 368);
	lv_obj_set_size(ui->screen_btnm_y_pic, 358, 55);

	//Write style for screen_btnm_y_pic, Part: LV_PART_MAIN, State: LV_STATE_DEFAULT.
	lv_obj_set_style_border_width(ui->screen_btnm_y_pic, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_top(ui->screen_btnm_y_pic, 4, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_bottom(ui->screen_btnm_y_pic, 4, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_left(ui->screen_btnm_y_pic, 20, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_right(ui->screen_btnm_y_pic, 20, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_row(ui->screen_btnm_y_pic, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_column(ui->screen_btnm_y_pic, 25, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_btnm_y_pic, 5, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_opa(ui->screen_btnm_y_pic, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen_btnm_y_pic, lv_color_hex(0xD4CC89), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen_btnm_y_pic, LV_GRAD_DIR_NONE, LV_PART_MAIN|LV_STATE_DEFAULT);

	//Write style for screen_btnm_y_pic, Part: LV_PART_ITEMS, State: LV_STATE_DEFAULT.
	lv_obj_set_style_border_width(ui->screen_btnm_y_pic, 1, LV_PART_ITEMS|LV_STATE_DEFAULT);
	lv_obj_set_style_border_opa(ui->screen_btnm_y_pic, 255, LV_PART_ITEMS|LV_STATE_DEFAULT);
	lv_obj_set_style_border_color(ui->screen_btnm_y_pic, lv_color_hex(0xc9c9c9), LV_PART_ITEMS|LV_STATE_DEFAULT);
	lv_obj_set_style_border_side(ui->screen_btnm_y_pic, LV_BORDER_SIDE_FULL, LV_PART_ITEMS|LV_STATE_DEFAULT);
	lv_obj_set_style_text_color(ui->screen_btnm_y_pic, lv_color_hex(0xD4C988), LV_PART_ITEMS|LV_STATE_DEFAULT);
	lv_obj_set_style_text_font(ui->screen_btnm_y_pic, &lv_font_MI_LanTing_Regular_28, LV_PART_ITEMS|LV_STATE_DEFAULT);
	lv_obj_set_style_text_opa(ui->screen_btnm_y_pic, 255, LV_PART_ITEMS|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_btnm_y_pic, 4, LV_PART_ITEMS|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_opa(ui->screen_btnm_y_pic, 255, LV_PART_ITEMS|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen_btnm_y_pic, lv_color_hex(0x18125C), LV_PART_ITEMS|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen_btnm_y_pic, LV_GRAD_DIR_NONE, LV_PART_ITEMS|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_width(ui->screen_btnm_y_pic, 0, LV_PART_ITEMS|LV_STATE_DEFAULT);

	//Write codes screen_label_vid_format
	ui->screen_label_vid_format = lv_label_create(ui->screen);
	lv_label_set_text(ui->screen_label_vid_format, "输出格式");
	lv_label_set_long_mode(ui->screen_label_vid_format, LV_LABEL_LONG_WRAP);
	lv_obj_set_pos(ui->screen_label_vid_format, 30, 61);
	lv_obj_set_size(ui->screen_label_vid_format, 120, 20);

	//Write style for screen_label_vid_format, Part: LV_PART_MAIN, State: LV_STATE_DEFAULT.
	lv_obj_set_style_border_width(ui->screen_label_vid_format, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_label_vid_format, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_color(ui->screen_label_vid_format, lv_color_hex(0x18125C), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_font(ui->screen_label_vid_format, &lv_font_MI_LanTing_Regular_18, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_opa(ui->screen_label_vid_format, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_letter_space(ui->screen_label_vid_format, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_line_space(ui->screen_label_vid_format, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_align(ui->screen_label_vid_format, LV_TEXT_ALIGN_CENTER, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_opa(ui->screen_label_vid_format, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen_label_vid_format, lv_color_hex(0xD4CC89), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen_label_vid_format, LV_GRAD_DIR_NONE, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_top(ui->screen_label_vid_format, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_right(ui->screen_label_vid_format, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_bottom(ui->screen_label_vid_format, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_left(ui->screen_label_vid_format, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_width(ui->screen_label_vid_format, 0, LV_PART_MAIN|LV_STATE_DEFAULT);

	//Write codes screen_label_6
	ui->screen_label_6 = lv_label_create(ui->screen);
	lv_label_set_text(ui->screen_label_6, "缩放算法");
	lv_label_set_long_mode(ui->screen_label_6, LV_LABEL_LONG_WRAP);
	lv_obj_set_pos(ui->screen_label_6, 173, 61);
	lv_obj_set_size(ui->screen_label_6, 90, 20);

	//Write style for screen_label_6, Part: LV_PART_MAIN, State: LV_STATE_DEFAULT.
	lv_obj_set_style_border_width(ui->screen_label_6, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_label_6, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_color(ui->screen_label_6, lv_color_hex(0x18125C), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_font(ui->screen_label_6, &lv_font_MI_LanTing_Regular_18, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_opa(ui->screen_label_6, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_letter_space(ui->screen_label_6, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_line_space(ui->screen_label_6, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_align(ui->screen_label_6, LV_TEXT_ALIGN_CENTER, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_opa(ui->screen_label_6, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen_label_6, lv_color_hex(0xD4CC89), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen_label_6, LV_GRAD_DIR_NONE, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_top(ui->screen_label_6, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_right(ui->screen_label_6, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_bottom(ui->screen_label_6, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_left(ui->screen_label_6, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_width(ui->screen_label_6, 0, LV_PART_MAIN|LV_STATE_DEFAULT);

	//Write codes screen_ddlist_vid_format
	ui->screen_ddlist_vid_format = lv_dropdown_create(ui->screen);
	lv_dropdown_set_options(ui->screen_ddlist_vid_format, "1080p@60\n2k@30");
	lv_obj_set_pos(ui->screen_ddlist_vid_format, 30, 25);
	lv_obj_set_size(ui->screen_ddlist_vid_format, 120, 36);

	//Write style for screen_ddlist_vid_format, Part: LV_PART_MAIN, State: LV_STATE_DEFAULT.
	lv_obj_set_style_text_color(ui->screen_ddlist_vid_format, lv_color_hex(0x0D3055), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_font(ui->screen_ddlist_vid_format, &lv_font_MI_LanTing_Regular_18, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_opa(ui->screen_ddlist_vid_format, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_width(ui->screen_ddlist_vid_format, 2, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_opa(ui->screen_ddlist_vid_format, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_color(ui->screen_ddlist_vid_format, lv_color_hex(0x18125C), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_side(ui->screen_ddlist_vid_format, LV_BORDER_SIDE_FULL, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_top(ui->screen_ddlist_vid_format, 8, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_left(ui->screen_ddlist_vid_format, 6, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_right(ui->screen_ddlist_vid_format, 6, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_ddlist_vid_format, 3, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_opa(ui->screen_ddlist_vid_format, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen_ddlist_vid_format, lv_color_hex(0xD4CC89), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen_ddlist_vid_format, LV_GRAD_DIR_NONE, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_width(ui->screen_ddlist_vid_format, 0, LV_PART_MAIN|LV_STATE_DEFAULT);

	//Write style state: LV_STATE_CHECKED for &style_screen_ddlist_vid_format_extra_list_selected_checked
	static lv_style_t style_screen_ddlist_vid_format_extra_list_selected_checked;
	ui_init_style(&style_screen_ddlist_vid_format_extra_list_selected_checked);
	
	lv_style_set_border_width(&style_screen_ddlist_vid_format_extra_list_selected_checked, 1);
	lv_style_set_border_opa(&style_screen_ddlist_vid_format_extra_list_selected_checked, 255);
	lv_style_set_border_color(&style_screen_ddlist_vid_format_extra_list_selected_checked, lv_color_hex(0xe1e6ee));
	lv_style_set_border_side(&style_screen_ddlist_vid_format_extra_list_selected_checked, LV_BORDER_SIDE_FULL);
	lv_style_set_radius(&style_screen_ddlist_vid_format_extra_list_selected_checked, 3);
	lv_style_set_bg_opa(&style_screen_ddlist_vid_format_extra_list_selected_checked, 255);
	lv_style_set_bg_color(&style_screen_ddlist_vid_format_extra_list_selected_checked, lv_color_hex(0x00a1b5));
	lv_style_set_bg_grad_dir(&style_screen_ddlist_vid_format_extra_list_selected_checked, LV_GRAD_DIR_NONE);
	lv_obj_add_style(lv_dropdown_get_list(ui->screen_ddlist_vid_format), &style_screen_ddlist_vid_format_extra_list_selected_checked, LV_PART_SELECTED|LV_STATE_CHECKED);

	//Write style state: LV_STATE_DEFAULT for &style_screen_ddlist_vid_format_extra_list_main_default
	static lv_style_t style_screen_ddlist_vid_format_extra_list_main_default;
	ui_init_style(&style_screen_ddlist_vid_format_extra_list_main_default);
	
	lv_style_set_max_height(&style_screen_ddlist_vid_format_extra_list_main_default, 90);
	lv_style_set_text_color(&style_screen_ddlist_vid_format_extra_list_main_default, lv_color_hex(0x0D3055));
	lv_style_set_text_font(&style_screen_ddlist_vid_format_extra_list_main_default, &lv_font_MI_LanTing_Regular_12);
	lv_style_set_text_opa(&style_screen_ddlist_vid_format_extra_list_main_default, 255);
	lv_style_set_border_width(&style_screen_ddlist_vid_format_extra_list_main_default, 1);
	lv_style_set_border_opa(&style_screen_ddlist_vid_format_extra_list_main_default, 255);
	lv_style_set_border_color(&style_screen_ddlist_vid_format_extra_list_main_default, lv_color_hex(0xe1e6ee));
	lv_style_set_border_side(&style_screen_ddlist_vid_format_extra_list_main_default, LV_BORDER_SIDE_FULL);
	lv_style_set_radius(&style_screen_ddlist_vid_format_extra_list_main_default, 3);
	lv_style_set_bg_opa(&style_screen_ddlist_vid_format_extra_list_main_default, 255);
	lv_style_set_bg_color(&style_screen_ddlist_vid_format_extra_list_main_default, lv_color_hex(0xffffff));
	lv_style_set_bg_grad_dir(&style_screen_ddlist_vid_format_extra_list_main_default, LV_GRAD_DIR_NONE);
	lv_obj_add_style(lv_dropdown_get_list(ui->screen_ddlist_vid_format), &style_screen_ddlist_vid_format_extra_list_main_default, LV_PART_MAIN|LV_STATE_DEFAULT);

	//Write style state: LV_STATE_DEFAULT for &style_screen_ddlist_vid_format_extra_list_scrollbar_default
	static lv_style_t style_screen_ddlist_vid_format_extra_list_scrollbar_default;
	ui_init_style(&style_screen_ddlist_vid_format_extra_list_scrollbar_default);
	
	lv_style_set_radius(&style_screen_ddlist_vid_format_extra_list_scrollbar_default, 3);
	lv_style_set_bg_opa(&style_screen_ddlist_vid_format_extra_list_scrollbar_default, 255);
	lv_style_set_bg_color(&style_screen_ddlist_vid_format_extra_list_scrollbar_default, lv_color_hex(0x00ff00));
	lv_style_set_bg_grad_dir(&style_screen_ddlist_vid_format_extra_list_scrollbar_default, LV_GRAD_DIR_NONE);
	lv_obj_add_style(lv_dropdown_get_list(ui->screen_ddlist_vid_format), &style_screen_ddlist_vid_format_extra_list_scrollbar_default, LV_PART_SCROLLBAR|LV_STATE_DEFAULT);

	//Write codes screen_ddlist_algorithm
	ui->screen_ddlist_algorithm = lv_dropdown_create(ui->screen);
	lv_dropdown_set_options(ui->screen_ddlist_algorithm, "最近临\n双线性\n双三次");
	lv_dropdown_set_selected(ui->screen_ddlist_algorithm,1);
	lv_obj_set_pos(ui->screen_ddlist_algorithm, 173, 25);
	lv_obj_set_size(ui->screen_ddlist_algorithm, 90, 36);

	//Write style for screen_ddlist_algorithm, Part: LV_PART_MAIN, State: LV_STATE_DEFAULT.
	lv_obj_set_style_text_color(ui->screen_ddlist_algorithm, lv_color_hex(0x0D3055), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_font(ui->screen_ddlist_algorithm, &lv_font_MI_LanTing_Regular_18, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_opa(ui->screen_ddlist_algorithm, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_width(ui->screen_ddlist_algorithm, 2, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_opa(ui->screen_ddlist_algorithm, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_color(ui->screen_ddlist_algorithm, lv_color_hex(0x18125C), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_side(ui->screen_ddlist_algorithm, LV_BORDER_SIDE_FULL, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_top(ui->screen_ddlist_algorithm, 8, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_left(ui->screen_ddlist_algorithm, 6, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_right(ui->screen_ddlist_algorithm, 6, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_ddlist_algorithm, 3, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_opa(ui->screen_ddlist_algorithm, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen_ddlist_algorithm, lv_color_hex(0xD4CC89), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen_ddlist_algorithm, LV_GRAD_DIR_NONE, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_width(ui->screen_ddlist_algorithm, 0, LV_PART_MAIN|LV_STATE_DEFAULT);

	//Write style state: LV_STATE_CHECKED for &style_screen_ddlist_algorithm_extra_list_selected_checked
	static lv_style_t style_screen_ddlist_algorithm_extra_list_selected_checked;
	ui_init_style(&style_screen_ddlist_algorithm_extra_list_selected_checked);
	
	lv_style_set_border_width(&style_screen_ddlist_algorithm_extra_list_selected_checked, 1);
	lv_style_set_border_opa(&style_screen_ddlist_algorithm_extra_list_selected_checked, 255);
	lv_style_set_border_color(&style_screen_ddlist_algorithm_extra_list_selected_checked, lv_color_hex(0xe1e6ee));
	lv_style_set_border_side(&style_screen_ddlist_algorithm_extra_list_selected_checked, LV_BORDER_SIDE_FULL);
	lv_style_set_radius(&style_screen_ddlist_algorithm_extra_list_selected_checked, 3);
	lv_style_set_bg_opa(&style_screen_ddlist_algorithm_extra_list_selected_checked, 255);
	lv_style_set_bg_color(&style_screen_ddlist_algorithm_extra_list_selected_checked, lv_color_hex(0x00a1b5));
	lv_style_set_bg_grad_dir(&style_screen_ddlist_algorithm_extra_list_selected_checked, LV_GRAD_DIR_NONE);
	lv_obj_add_style(lv_dropdown_get_list(ui->screen_ddlist_algorithm), &style_screen_ddlist_algorithm_extra_list_selected_checked, LV_PART_SELECTED|LV_STATE_CHECKED);

	//Write style state: LV_STATE_DEFAULT for &style_screen_ddlist_algorithm_extra_list_main_default
	static lv_style_t style_screen_ddlist_algorithm_extra_list_main_default;
	ui_init_style(&style_screen_ddlist_algorithm_extra_list_main_default);
	
	lv_style_set_max_height(&style_screen_ddlist_algorithm_extra_list_main_default, 90);
	lv_style_set_text_color(&style_screen_ddlist_algorithm_extra_list_main_default, lv_color_hex(0x0D3055));
	lv_style_set_text_font(&style_screen_ddlist_algorithm_extra_list_main_default, &lv_font_MI_LanTing_Regular_12);
	lv_style_set_text_opa(&style_screen_ddlist_algorithm_extra_list_main_default, 255);
	lv_style_set_border_width(&style_screen_ddlist_algorithm_extra_list_main_default, 1);
	lv_style_set_border_opa(&style_screen_ddlist_algorithm_extra_list_main_default, 255);
	lv_style_set_border_color(&style_screen_ddlist_algorithm_extra_list_main_default, lv_color_hex(0xe1e6ee));
	lv_style_set_border_side(&style_screen_ddlist_algorithm_extra_list_main_default, LV_BORDER_SIDE_FULL);
	lv_style_set_radius(&style_screen_ddlist_algorithm_extra_list_main_default, 3);
	lv_style_set_bg_opa(&style_screen_ddlist_algorithm_extra_list_main_default, 255);
	lv_style_set_bg_color(&style_screen_ddlist_algorithm_extra_list_main_default, lv_color_hex(0xffffff));
	lv_style_set_bg_grad_dir(&style_screen_ddlist_algorithm_extra_list_main_default, LV_GRAD_DIR_NONE);
	lv_obj_add_style(lv_dropdown_get_list(ui->screen_ddlist_algorithm), &style_screen_ddlist_algorithm_extra_list_main_default, LV_PART_MAIN|LV_STATE_DEFAULT);

	//Write style state: LV_STATE_DEFAULT for &style_screen_ddlist_algorithm_extra_list_scrollbar_default
	static lv_style_t style_screen_ddlist_algorithm_extra_list_scrollbar_default;
	ui_init_style(&style_screen_ddlist_algorithm_extra_list_scrollbar_default);
	
	lv_style_set_radius(&style_screen_ddlist_algorithm_extra_list_scrollbar_default, 3);
	lv_style_set_bg_opa(&style_screen_ddlist_algorithm_extra_list_scrollbar_default, 255);
	lv_style_set_bg_color(&style_screen_ddlist_algorithm_extra_list_scrollbar_default, lv_color_hex(0x00ff00));
	lv_style_set_bg_grad_dir(&style_screen_ddlist_algorithm_extra_list_scrollbar_default, LV_GRAD_DIR_NONE);
	lv_obj_add_style(lv_dropdown_get_list(ui->screen_ddlist_algorithm), &style_screen_ddlist_algorithm_extra_list_scrollbar_default, LV_PART_SCROLLBAR|LV_STATE_DEFAULT);

	//Write codes screen_Alpha_cont
	ui->screen_Alpha_cont = lv_obj_create(ui->screen);
	lv_obj_set_pos(ui->screen_Alpha_cont, 0, 0);
	lv_obj_set_size(ui->screen_Alpha_cont, 800, 109);
	lv_obj_set_scrollbar_mode(ui->screen_Alpha_cont, LV_SCROLLBAR_MODE_OFF);
	lv_obj_add_flag(ui->screen_Alpha_cont, LV_OBJ_FLAG_HIDDEN);
	lv_obj_add_flag(ui->screen_Alpha_cont, LV_OBJ_FLAG_HIDDEN);

	//Write style for screen_Alpha_cont, Part: LV_PART_MAIN, State: LV_STATE_DEFAULT.
	lv_obj_set_style_border_width(ui->screen_Alpha_cont, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_Alpha_cont, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_opa(ui->screen_Alpha_cont, 153, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen_Alpha_cont, lv_color_hex(0x18125C), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen_Alpha_cont, LV_GRAD_DIR_HOR, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_color(ui->screen_Alpha_cont, lv_color_hex(0xBCBAD0), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_main_stop(ui->screen_Alpha_cont, 185, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_stop(ui->screen_Alpha_cont, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_top(ui->screen_Alpha_cont, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_bottom(ui->screen_Alpha_cont, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_left(ui->screen_Alpha_cont, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_right(ui->screen_Alpha_cont, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_width(ui->screen_Alpha_cont, 0, LV_PART_MAIN|LV_STATE_DEFAULT);

	//Write codes screen_slider_a
	ui->screen_slider_a = lv_slider_create(ui->screen_Alpha_cont);
	lv_slider_set_range(ui->screen_slider_a, 0, 400);
	lv_slider_set_mode(ui->screen_slider_a, LV_SLIDER_MODE_NORMAL);
	lv_slider_set_value(ui->screen_slider_a, 300, LV_ANIM_OFF);
	lv_obj_set_pos(ui->screen_slider_a, 30, 70);
	lv_obj_set_size(ui->screen_slider_a, 740, 25);

	//Write style for screen_slider_a, Part: LV_PART_MAIN, State: LV_STATE_DEFAULT.
	lv_obj_set_style_bg_opa(ui->screen_slider_a, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen_slider_a, lv_color_hex(0xffffff), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen_slider_a, LV_GRAD_DIR_NONE, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_slider_a, 50, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_outline_width(ui->screen_slider_a, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_width(ui->screen_slider_a, 0, LV_PART_MAIN|LV_STATE_DEFAULT);

	//Write style for screen_slider_a, Part: LV_PART_INDICATOR, State: LV_STATE_DEFAULT.
	lv_obj_set_style_bg_opa(ui->screen_slider_a, 255, LV_PART_INDICATOR|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen_slider_a, lv_color_hex(0xD4CC89), LV_PART_INDICATOR|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen_slider_a, LV_GRAD_DIR_NONE, LV_PART_INDICATOR|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_slider_a, 50, LV_PART_INDICATOR|LV_STATE_DEFAULT);

	//Write style for screen_slider_a, Part: LV_PART_KNOB, State: LV_STATE_DEFAULT.
	lv_obj_set_style_bg_opa(ui->screen_slider_a, 255, LV_PART_KNOB|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen_slider_a, lv_color_hex(0x00ed5c), LV_PART_KNOB|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen_slider_a, LV_GRAD_DIR_NONE, LV_PART_KNOB|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_slider_a, 50, LV_PART_KNOB|LV_STATE_DEFAULT);

	//Write codes screen_label_a
	ui->screen_label_a = lv_label_create(ui->screen_Alpha_cont);
	lv_label_set_text(ui->screen_label_a, "BiCubic函数a值：");
	lv_label_set_long_mode(ui->screen_label_a, LV_LABEL_LONG_WRAP);
	lv_obj_set_pos(ui->screen_label_a, 30, 15);
	lv_obj_set_size(ui->screen_label_a, 255, 32);

	//Write style for screen_label_a, Part: LV_PART_MAIN, State: LV_STATE_DEFAULT.
	lv_obj_set_style_border_width(ui->screen_label_a, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_label_a, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_color(ui->screen_label_a, lv_color_hex(0x18125C), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_font(ui->screen_label_a, &lv_font_MI_LanTing_Regular_28, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_opa(ui->screen_label_a, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_letter_space(ui->screen_label_a, 2, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_line_space(ui->screen_label_a, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_align(ui->screen_label_a, LV_TEXT_ALIGN_CENTER, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_opa(ui->screen_label_a, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen_label_a, lv_color_hex(0xD4CC89), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen_label_a, LV_GRAD_DIR_NONE, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_top(ui->screen_label_a, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_right(ui->screen_label_a, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_bottom(ui->screen_label_a, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_left(ui->screen_label_a, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_width(ui->screen_label_a, 0, LV_PART_MAIN|LV_STATE_DEFAULT);

	//Write codes screen_label_a_value
	ui->screen_label_a_value = lv_label_create(ui->screen_Alpha_cont);
	lv_label_set_text(ui->screen_label_a_value, "-0.500");
	lv_label_set_long_mode(ui->screen_label_a_value, LV_LABEL_LONG_WRAP);
	lv_obj_set_pos(ui->screen_label_a_value, 300, 15);
	lv_obj_set_size(ui->screen_label_a_value, 100, 32);

	//Write style for screen_label_a_value, Part: LV_PART_MAIN, State: LV_STATE_DEFAULT.
	lv_obj_set_style_border_width(ui->screen_label_a_value, 2, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_opa(ui->screen_label_a_value, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_color(ui->screen_label_a_value, lv_color_hex(0x18125C), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_side(ui->screen_label_a_value, LV_BORDER_SIDE_FULL, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_label_a_value, 2, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_color(ui->screen_label_a_value, lv_color_hex(0x18125C), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_font(ui->screen_label_a_value, &lv_font_MI_LanTing_Regular_28, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_opa(ui->screen_label_a_value, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_letter_space(ui->screen_label_a_value, 1, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_line_space(ui->screen_label_a_value, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_align(ui->screen_label_a_value, LV_TEXT_ALIGN_CENTER, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_opa(ui->screen_label_a_value, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen_label_a_value, lv_color_hex(0xffffff), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen_label_a_value, LV_GRAD_DIR_NONE, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_top(ui->screen_label_a_value, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_right(ui->screen_label_a_value, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_bottom(ui->screen_label_a_value, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_pad_left(ui->screen_label_a_value, 0, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_width(ui->screen_label_a_value, 0, LV_PART_MAIN|LV_STATE_DEFAULT);

	//Write codes screen_btn_1
	ui->screen_btn_1 = lv_btn_create(ui->screen_Alpha_cont);
	ui->screen_btn_1_label = lv_label_create(ui->screen_btn_1);
	lv_label_set_text(ui->screen_btn_1_label, "返回");
	lv_label_set_long_mode(ui->screen_btn_1_label, LV_LABEL_LONG_WRAP);
	lv_obj_align(ui->screen_btn_1_label, LV_ALIGN_CENTER, 0, 0);
	lv_obj_set_style_pad_all(ui->screen_btn_1, 0, LV_STATE_DEFAULT);
	lv_obj_set_width(ui->screen_btn_1_label, LV_PCT(100));
	lv_obj_set_pos(ui->screen_btn_1, 540, 5);
	lv_obj_set_size(ui->screen_btn_1, 240, 45);

	//Write style for screen_btn_1, Part: LV_PART_MAIN, State: LV_STATE_DEFAULT.
	lv_obj_set_style_bg_opa(ui->screen_btn_1, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_color(ui->screen_btn_1, lv_color_hex(0x18125C), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_bg_grad_dir(ui->screen_btn_1, LV_GRAD_DIR_NONE, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_width(ui->screen_btn_1, 5, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_opa(ui->screen_btn_1, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_color(ui->screen_btn_1, lv_color_hex(0xD4C988), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_border_side(ui->screen_btn_1, LV_BORDER_SIDE_FULL, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_radius(ui->screen_btn_1, 5, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_width(ui->screen_btn_1, 5, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_color(ui->screen_btn_1, lv_color_hex(0x000000), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_opa(ui->screen_btn_1, 79, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_spread(ui->screen_btn_1, 5, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_ofs_x(ui->screen_btn_1, -4, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_shadow_ofs_y(ui->screen_btn_1, 4, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_color(ui->screen_btn_1, lv_color_hex(0xD4C988), LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_font(ui->screen_btn_1, &lv_font_MI_LanTing_Regular_28, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_opa(ui->screen_btn_1, 255, LV_PART_MAIN|LV_STATE_DEFAULT);
	lv_obj_set_style_text_align(ui->screen_btn_1, LV_TEXT_ALIGN_CENTER, LV_PART_MAIN|LV_STATE_DEFAULT);

	//The custom code of screen.
	

	//Update current screen layout.
	lv_obj_update_layout(ui->screen);

	//Init events for screen.
	events_init_screen(ui);
}
