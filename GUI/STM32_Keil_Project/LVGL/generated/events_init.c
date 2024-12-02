/*
* Copyright 2024 NXP
* NXP Confidential and Proprietary. This software is owned or controlled by NXP and may only be used strictly in
* accordance with the applicable license terms. By expressly accepting such terms or by downloading, installing,
* activating and/or otherwise using the software, you are agreeing that you have read, and that you agree to
* comply with and are bound by, such license terms.  If you do not agree to be bound by the applicable license
* terms, then you may not retain, install, activate or otherwise use the software.
*/

#include "events_init.h"
#include <stdio.h>
#include "lvgl.h"
#include "app.h"

#if LV_USE_FREEMASTER
#include "freemaster_client.h"
#endif


static void screen_slider_x_pix_event_handler (lv_event_t *e)
{
	lv_event_code_t code = lv_event_get_code(e);

	switch (code) {
	case LV_EVENT_PRESSED:
	{
		slider_pressed_callback();
		ui_move_animation(guider_ui.screen_btn_select, 300, 0, 65, 40, &lv_anim_path_bounce, 0, 0, 0, 0, NULL, NULL, NULL);
		ui_scale_animation(guider_ui.screen_btn_select, 400, 0, 125, 70, &lv_anim_path_bounce, 0, 0, 0, 0, NULL, NULL, NULL);
		break;
	}
	case LV_EVENT_VALUE_CHANGED:
	{
		//lv_obj_clear_flag(guider_ui.screen_slider_x_pix, LV_OBJ_FLAG_HIDDEN);
		slider_x_value_changed_callback();
		break;
	}
	default:
		break;
	}
}
static void screen_btn_hand_set_event_handler (lv_event_t *e)
{
	lv_event_code_t code = lv_event_get_code(e);

	switch (code) {
	case LV_EVENT_SHORT_CLICKED:
	{
		ui_move_animation(guider_ui.screen_btn_select, 300, 0, 65, 40, &lv_anim_path_bounce, 0, 0, 0, 0, NULL, NULL, NULL);
		ui_scale_animation(guider_ui.screen_btn_select, 400, 0, 125, 70, &lv_anim_path_bounce, 0, 0, 0, 0, NULL, NULL, NULL);
		btn_hand_set_callback();
		break;
	}
	default:
		break;
	}
}
static void screen_btn_demo_linear_event_handler (lv_event_t *e)
{
	lv_event_code_t code = lv_event_get_code(e);

	switch (code) {
	case LV_EVENT_SHORT_CLICKED:
	{
		ui_move_animation(guider_ui.screen_btn_select, 300, 0, 450, 15, &lv_anim_path_bounce, 0, 0, 0, 0, NULL, NULL, NULL);
		ui_scale_animation(guider_ui.screen_btn_select, 400, 0, 263, 50, &lv_anim_path_bounce, 0, 0, 0, 0, NULL, NULL, NULL);
		btn_linear_demo_callback();
		break;
	}
	default:
		break;
	}
}
static void screen_btn_demo_nonlinear_event_handler (lv_event_t *e)
{
	lv_event_code_t code = lv_event_get_code(e);

	switch (code) {
	case LV_EVENT_SHORT_CLICKED:
	{
		ui_move_animation(guider_ui.screen_btn_select, 300, 0, 450, 85, &lv_anim_path_bounce, 0, 0, 0, 0, NULL, NULL, NULL);
		ui_scale_animation(guider_ui.screen_btn_select, 400, 0, 265, 50, &lv_anim_path_bounce, 0, 0, 0, 0, NULL, NULL, NULL);
		btn_nonlinear_demo_callback();
		break;
	}
	default:
		break;
	}
}
static void screen_ddlist_nonlinear_event_handler (lv_event_t *e)
{
	lv_event_code_t code = lv_event_get_code(e);

	switch (code) {
	case LV_EVENT_VALUE_CHANGED:
	{
		ddlist_mode_value_changed_callback();
		//lv_obj_clear_flag(guider_ui.screen_ddlist_nonlinear, LV_OBJ_FLAG_HIDDEN);
		//uint16_t id = lv_dropdown_get_selected(guider_ui.screen_ddlist_nonlinear);
		//switch(id) {
		//default:
		//	break;
		//}
		break;
	}
	default:
		break;
	}
}
static void screen_img_1_event_handler (lv_event_t *e)
{
	lv_event_code_t code = lv_event_get_code(e);

	switch (code) {
	case LV_EVENT_CLICKED:
	{
		//lv_obj_clear_flag(guider_ui.screen_Alpha_cont, LV_OBJ_FLAG_HIDDEN);
		img_click_callback();
		break;
	}
	default:
		break;
	}
}
static void screen_ddlist_min_event_handler (lv_event_t *e)
{
	lv_event_code_t code = lv_event_get_code(e);

	switch (code) {
	case LV_EVENT_VALUE_CHANGED:
	{
		//lv_obj_clear_flag(guider_ui.screen_ddlist_min, LV_OBJ_FLAG_HIDDEN);
		//uint16_t id = lv_dropdown_get_selected(guider_ui.screen_ddlist_min);
		//switch(id) {
		//default:
		//	break;
		//}
		ddlist_min_value_changed_callback();
		break;
	}
	default:
		break;
	}
}
static void screen_ddlist_max_event_handler (lv_event_t *e)
{
	lv_event_code_t code = lv_event_get_code(e);

	switch (code) {
	case LV_EVENT_VALUE_CHANGED:
	{
		ddlist_max_value_changed_callback();
		//lv_obj_clear_flag(guider_ui.screen_ddlist_max, LV_OBJ_FLAG_HIDDEN);
		//uint16_t id = lv_dropdown_get_selected(guider_ui.screen_ddlist_max);
		//switch(id) {
		//default:
		//	break;
		//}
		break;
	}
	default:
		break;
	}
}
static void screen_slider_y_pix_event_handler (lv_event_t *e)
{
	lv_event_code_t code = lv_event_get_code(e);

	switch (code) {
	case LV_EVENT_VALUE_CHANGED:
	{
		slider_y_value_changed_callback();
		//lv_obj_clear_flag(guider_ui.screen_slider_y_pix, LV_OBJ_FLAG_HIDDEN);
		break;
	}
	case LV_EVENT_PRESSED:
	{
		slider_pressed_callback();
		ui_move_animation(guider_ui.screen_btn_select, 300, 0, 65, 40, &lv_anim_path_bounce, 0, 0, 0, 0, NULL, NULL, NULL);
		ui_scale_animation(guider_ui.screen_btn_select, 400, 0, 125, 70, &lv_anim_path_bounce, 0, 0, 0, 0, NULL, NULL, NULL);
		break;
	}
	default:
		break;
	}
}
static void screen_btnm_x_pic_event_handler (lv_event_t *e)
{
	lv_event_code_t code = lv_event_get_code(e);

	switch (code) {
	case LV_EVENT_PRESSED:
	{
		lv_obj_t * obj = lv_event_get_target(e);
		uint32_t id = lv_btnmatrix_get_selected_btn(obj);
		switch(id) {
		case 0:
		{
			btn_x_minus_callback();			
			btn_x_y_callback();
			lv_obj_clear_flag(guider_ui.screen_btnm_x_pic, LV_OBJ_FLAG_HIDDEN);
			ui_move_animation(guider_ui.screen_btn_select, 300, 0, 65, 40, &lv_anim_path_bounce, 0, 0, 0, 0, NULL, NULL, NULL);
			ui_scale_animation(guider_ui.screen_btn_select, 400, 0, 125, 70, &lv_anim_path_bounce, 0, 0, 0, 0, NULL, NULL, NULL);
			break;
		}
		case 1:
		{
			btn_x_plus_callback();
			btn_x_y_callback();
			//printf("btnm_x+pressed\n");
			lv_obj_clear_flag(guider_ui.screen_btnm_x_pic, LV_OBJ_FLAG_HIDDEN);
			ui_move_animation(guider_ui.screen_btn_select, 300, 0, 65, 40, &lv_anim_path_bounce, 0, 0, 0, 0, NULL, NULL, NULL);
			ui_scale_animation(guider_ui.screen_btn_select, 400, 0, 125, 70, &lv_anim_path_bounce, 0, 0, 0, 0, NULL, NULL, NULL);
			break;
		}
		default:
			break;
		}
	}
	
		case LV_EVENT_PRESSING:
	{
		lv_obj_t * obj = lv_event_get_target(e);
		uint32_t id = lv_btnmatrix_get_selected_btn(obj);
		switch(id) {
			case 0:
			{
				btn_x_y_pressing_callback();
				btn_x_minus_pressing_callback();
				//printf("btnm_y_-\n");
				break;
			}
			case 1:
			{
				btn_x_y_pressing_callback();
				btn_x_plus_pressing_callback();
				//printf("btnm_y+pressing\n");
				break;
			}				
			
		default:
			break;			
		}
	}
	
	
	default:
		break;
	}
}
static void screen_btnm_y_pic_event_handler (lv_event_t *e)
{
	lv_event_code_t code = lv_event_get_code(e);

	switch (code) {
	case LV_EVENT_PRESSED:
	{
		lv_obj_t * obj = lv_event_get_target(e);
		uint32_t id = lv_btnmatrix_get_selected_btn(obj);
		switch(id) {
		case 0:
		{
			btn_y_minus_callback();
			btn_x_y_callback();
			lv_obj_clear_flag(guider_ui.screen_btnm_x_pic, LV_OBJ_FLAG_HIDDEN);
			ui_move_animation(guider_ui.screen_btn_select, 300, 0, 65, 40, &lv_anim_path_bounce, 0, 0, 0, 0, NULL, NULL, NULL);
			ui_scale_animation(guider_ui.screen_btn_select, 400, 0, 125, 70, &lv_anim_path_bounce, 0, 0, 0, 0, NULL, NULL, NULL);
			break;
		}
		case 1:
		{
			btn_y_plus_callback();
			btn_x_y_callback();
			lv_obj_clear_flag(guider_ui.screen_btnm_x_pic, LV_OBJ_FLAG_HIDDEN);
			ui_move_animation(guider_ui.screen_btn_select, 300, 0, 65, 40, &lv_anim_path_bounce, 0, 0, 0, 0, NULL, NULL, NULL);
			ui_scale_animation(guider_ui.screen_btn_select, 400, 0, 125, 70, &lv_anim_path_bounce, 0, 0, 0, 0, NULL, NULL, NULL);
			break;
		}
		default:
			break;
		}
	}
		case LV_EVENT_PRESSING:
	{
		lv_obj_t * obj = lv_event_get_target(e);
		uint32_t id = lv_btnmatrix_get_selected_btn(obj);
		switch(id) {
			case 0:
			{
				btn_x_y_pressing_callback();
				btn_y_minus_pressing_callback();
				//printf("btnm_y_-\n");
				break;
			}
			case 1:
			{
				btn_x_y_pressing_callback();
				btn_y_plus_pressing_callback();
				//printf("btnm_y_+\n");
				break;
			}				
			
		default:
			break;			
		}
	}
	default:
		break;
	}
}
static void screen_ddlist_vid_format_event_handler (lv_event_t *e)
{
	lv_event_code_t code = lv_event_get_code(e);

	switch (code) {
	case LV_EVENT_VALUE_CHANGED:
	{
		ddlist_vid_format_value_change_callback();
		//lv_obj_clear_flag(guider_ui.screen_ddlist_vid_format, LV_OBJ_FLAG_HIDDEN);
		//uint16_t id = lv_dropdown_get_selected(guider_ui.screen_ddlist_vid_format);
		//switch(id) {
		//default:
		//	break;
		//}
		break;
	}
	default:
		break;
	}
}
static void screen_ddlist_algorithm_event_handler (lv_event_t *e)
{
	lv_event_code_t code = lv_event_get_code(e);

	switch (code) {
	case LV_EVENT_VALUE_CHANGED:
	{
		ddlist_algorithm_value_change_callback();
		//lv_obj_clear_flag(guider_ui.screen_ddlist_algorithm, LV_OBJ_FLAG_HIDDEN);
		//uint16_t id = lv_dropdown_get_selected(guider_ui.screen_ddlist_algorithm);
		//switch(id) {
		//default:
		//	break;
		//}
		break;
	}
	default:
		break;
	}
}
static void screen_slider_a_event_handler (lv_event_t *e)
{
	lv_event_code_t code = lv_event_get_code(e);

	switch (code) {
	case LV_EVENT_VALUE_CHANGED:
	{
		slider_a_value_changed_callback();
		//lv_obj_clear_flag(guider_ui.screen_slider_a, LV_OBJ_FLAG_HIDDEN);
		break;
	}
	default:
		break;
	}
}
static void screen_btn_1_event_handler (lv_event_t *e)
{
	lv_event_code_t code = lv_event_get_code(e);

	switch (code) {
	case LV_EVENT_CLICKED:
	{
		lv_obj_add_flag(guider_ui.screen_Alpha_cont, LV_OBJ_FLAG_HIDDEN);
		break;
	}
	default:
		break;
	}
}
void events_init_screen(lv_ui *ui)
{
	lv_obj_add_event_cb(ui->screen_slider_x_pix, screen_slider_x_pix_event_handler, LV_EVENT_ALL, ui);
	lv_obj_add_event_cb(ui->screen_btn_hand_set, screen_btn_hand_set_event_handler, LV_EVENT_ALL, ui);
	lv_obj_add_event_cb(ui->screen_btn_demo_linear, screen_btn_demo_linear_event_handler, LV_EVENT_ALL, ui);
	lv_obj_add_event_cb(ui->screen_btn_demo_nonlinear, screen_btn_demo_nonlinear_event_handler, LV_EVENT_ALL, ui);
	lv_obj_add_event_cb(ui->screen_ddlist_nonlinear, screen_ddlist_nonlinear_event_handler, LV_EVENT_ALL, ui);
	lv_obj_add_event_cb(ui->screen_img_1, screen_img_1_event_handler, LV_EVENT_ALL, ui);
	lv_obj_add_event_cb(ui->screen_ddlist_min, screen_ddlist_min_event_handler, LV_EVENT_ALL, ui);
	lv_obj_add_event_cb(ui->screen_ddlist_max, screen_ddlist_max_event_handler, LV_EVENT_ALL, ui);
	lv_obj_add_event_cb(ui->screen_slider_y_pix, screen_slider_y_pix_event_handler, LV_EVENT_ALL, ui);
	lv_obj_add_event_cb(ui->screen_btnm_x_pic, screen_btnm_x_pic_event_handler, LV_EVENT_ALL, ui);
	lv_obj_add_event_cb(ui->screen_btnm_y_pic, screen_btnm_y_pic_event_handler, LV_EVENT_ALL, ui);
	lv_obj_add_event_cb(ui->screen_ddlist_vid_format, screen_ddlist_vid_format_event_handler, LV_EVENT_ALL, ui);
	lv_obj_add_event_cb(ui->screen_ddlist_algorithm, screen_ddlist_algorithm_event_handler, LV_EVENT_ALL, ui);
	lv_obj_add_event_cb(ui->screen_slider_a, screen_slider_a_event_handler, LV_EVENT_ALL, ui);
	lv_obj_add_event_cb(ui->screen_btn_1, screen_btn_1_event_handler, LV_EVENT_ALL, ui);
}

void events_init(lv_ui *ui)
{

}
