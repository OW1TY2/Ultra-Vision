#ifndef __APP_H
#define __APP_H

#include "main.h"
#include "usart.h"
#include "touch_800x480.h"
#include "math.h"
#include "stdio.h"
#include "tim.h"
#include "nonlinear_func.h"

#include "lvgl.h"
#include "lv_port_disp.h"
#include "lv_port_indev.h"
#include "gui_guider.h"
#include "events_init.h"
#include "widgets_init.h"

#define TIME 2
#define FPS (120)
static int max_x_pic=1920;//1920 2560 3840
static int min_x_pic=640;//640 320 160
static int max_y_pic=1080;//1080 1440 2160
static int min_y_pic=480;//480 240 120
	
int get_max_x_pic();
int get_min_x_pic();

static uint16_t last_x_value=640;
static uint16_t last_y_value=480;

#define HAND_SET_MODE 				(0)
#define DEMO_LINEAR_MODE			(1)
#define DEMO_NONLINEAR_MODE 	(2)
static uint8_t mode = HAND_SET_MODE;

#define BONCE_MODE	(0)
#define CIRC_MODE		(1)
#define QUINT_MODE		(2)
static uint8_t nonlinear_mode=BONCE_MODE;
static uint8_t last_nonlinear_mode=BONCE_MODE;

#define CNT_DOWN_FLAG	(0)
#define CNT_UP_FLAG		(1)

#define VID_FORMAT_1080P (0)
#define VID_FORMAT_4K		 (1)
static uint8_t cur_vid_format=VID_FORMAT_4K;
static uint8_t last_vid_format=VID_FORMAT_4K;

#define ALGORITHM_NNI (0) //最近临插值
#define ALGORITHM_BI	(1) //双线性插值
#define ALGORITHM_BCI	(2) //双三次插值
static uint8_t cur_algorithm=ALGORITHM_BI;
static uint8_t last_algorithm=ALGORITHM_BI;

typedef struct Controller_ {
	uint16_t x_pix_len;//当前大小
	float cnt;//自变量
	float time;//s
	float cnt_max;//自变量最大值
	int flag;//变化方向
	void (*next)(struct Controller_* con_);//递推函数
	void (*start)();
}controller;

static controller linear_control;
static controller Bounce_nonlinear_control;
static controller Circ_nonlinear_control;
static controller Quint_nonlinear_control;

void slider_pressed_callback();
void slider_x_value_changed_callback();
void slider_y_value_changed_callback();

void btn_linear_demo_callback();
void btn_nonlinear_demo_callback();
void btn_hand_set_callback();

void ddlist_mode_value_changed_callback();
void ddlist_max_value_changed_callback();
void ddlist_min_value_changed_callback();

void btn_x_plus_callback();
void btn_x_minus_callback();
void btn_y_plus_callback();
void btn_y_minus_callback();
void btn_x_y_callback();

#define PRESSING_CNT_MAX (25)
static uint8_t pressing_cnt=0;
#define PRESSED_CNT_MAX (10)
static uint8_t pressed_cnt=0;
void btn_x_plus_pressing_callback();
void btn_x_minus_pressing_callback();
void btn_y_plus_pressing_callback();
void btn_y_minus_pressing_callback();
void btn_x_y_pressing_callback();

void ddlist_vid_format_value_change_callback();
void ddlist_algorithm_value_change_callback();

static uint16_t last_a_slider_val=300;//0~400 == -2~0 (扣去 0 点)
static uint16_t cur_a_slider_val=300;//0~400 == -2~0 (扣去 0 点)

void slider_a_value_changed_callback();
void img_click_callback();

void app_init();
void app_mainloop();

#endif 