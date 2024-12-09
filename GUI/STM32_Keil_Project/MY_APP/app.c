#include "app.h"
lv_ui guider_ui;

controller* Cur_nonlinear_control = &Bounce_nonlinear_control;	

int get_max_x_pic()
{
	return max_x_pic;
}

int get_min_x_pic()
{
	return min_x_pic;
}

void linear_control_next(controller * contro)
{
	if(contro->flag==CNT_DOWN_FLAG)
	{
		contro->cnt=contro->cnt-1;
		if (contro->cnt<=0)
		{
			contro->flag=CNT_UP_FLAG;
			contro->cnt = 0;
		}
	}
	else if(contro->flag==CNT_UP_FLAG)
	{
		contro->cnt=contro->cnt+1;
		if (contro->cnt >= contro->cnt_max)
		{
			contro->flag=CNT_DOWN_FLAG;
			contro->cnt = contro->cnt_max;
		}
	}
	float temp=contro->cnt/contro->cnt_max;
	contro->x_pix_len = (float)(max_x_pic-min_x_pic)*temp+min_x_pic;
}

void Bounce_nonlinear_control_next(controller * contro)
{
	float temp;
		if(contro->flag==CNT_DOWN_FLAG)
	{
		contro->cnt=contro->cnt-1;
		temp=2*(contro->cnt/contro->cnt_max);
		contro->x_pix_len =(float)(max_x_pic-min_x_pic)*nonlinear_down_Bounce(temp)+min_x_pic;
		
		if (contro->cnt<=0)
		{
			contro->flag=CNT_UP_FLAG;
			contro->cnt=0;
		}
	}
	else if(contro->flag==CNT_UP_FLAG)
	{
		contro->cnt=contro->cnt+1;
		temp=2*(contro->cnt/contro->cnt_max);
		contro->x_pix_len =(float)(max_x_pic-min_x_pic)*nonlinear_up_Bounce(temp)+min_x_pic;		
		
		if (contro->cnt >= contro->cnt_max)
		{
			contro->flag=CNT_DOWN_FLAG;
			contro->cnt = contro->cnt_max;
		}
	}
}

void Circ_nonlinear_control_next(controller * contro)
{
		float temp;
		if(contro->flag==CNT_DOWN_FLAG)
	{
		contro->cnt=contro->cnt-1;
		temp=2*(contro->cnt/contro->cnt_max);
		contro->x_pix_len =(float)(max_x_pic-min_x_pic)*nonlinear_down_Circ(temp)+min_x_pic;
		
		if (contro->cnt<=0)
		{
			contro->flag=CNT_UP_FLAG;
			contro->cnt=0;
		}
	}
	else if(contro->flag==CNT_UP_FLAG)
	{
		contro->cnt=contro->cnt+1;
		temp=2*(contro->cnt/contro->cnt_max);
		contro->x_pix_len =(float)(max_x_pic-min_x_pic)*nonlinear_up_Circ(temp)+min_x_pic;		
		
		if (contro->cnt >= contro->cnt_max)
		{
			contro->flag=CNT_DOWN_FLAG;
			contro->cnt = contro->cnt_max;
		}
	}
}

void Quint_nonlinear_control_next(controller * contro)
{
			float temp;
		if(contro->flag==CNT_DOWN_FLAG)
	{
		contro->cnt=contro->cnt-1;
		temp=2*(contro->cnt/contro->cnt_max);
		contro->x_pix_len =(float)(max_x_pic-min_x_pic)*nonlinear_down_Quint(temp)+min_x_pic;
		
		if (contro->cnt<=0)
		{
			contro->flag=CNT_UP_FLAG;
			contro->cnt=0;
		}
	}
	else if(contro->flag==CNT_UP_FLAG)
	{
		contro->cnt=contro->cnt+1;
		temp=2*(contro->cnt/contro->cnt_max);
		contro->x_pix_len =(float)(max_x_pic-min_x_pic)*nonlinear_up_Quint(temp)+min_x_pic;		
		
		if (contro->cnt >= contro->cnt_max)
		{
			contro->flag=CNT_DOWN_FLAG;
			contro->cnt = contro->cnt_max;
		}
	}
}

void linear_control_start()
{
	linear_control.cnt=(uint16_t)((((float)last_x_value)-min_x_pic)*linear_control.cnt_max/(float)(max_x_pic-min_x_pic));
	linear_control.flag=CNT_UP_FLAG;
}

void Bounce_nonlinear_control_start()
{
	Bounce_nonlinear_control.cnt=(uint16_t)(cal_nonlinear_Bounce_cnt(last_x_value)*Bounce_nonlinear_control.cnt_max);
	Bounce_nonlinear_control.flag=CNT_UP_FLAG;
}

void Circ_nonlinear_control_start()
{
	Circ_nonlinear_control.cnt=(uint16_t)(cal_nonlinear_Circ_cnt(last_x_value)*Circ_nonlinear_control.cnt_max);
	Circ_nonlinear_control.flag=CNT_UP_FLAG;
}

void Quint_nonlinear_control_start()
{
	Quint_nonlinear_control.cnt=(uint16_t)(cal_nonlinear_Quint_cnt(last_x_value)*Quint_nonlinear_control.cnt_max);
	Quint_nonlinear_control.flag=CNT_UP_FLAG;
}

void restart_all()
{
	linear_control_start();
	Bounce_nonlinear_control_start();
	Circ_nonlinear_control_start();
	Quint_nonlinear_control_start();
}

void linear_control_init()
{
	linear_control.next=linear_control_next;
	linear_control.time=TIME;
	linear_control.cnt=0;
	linear_control.cnt_max=linear_control.time*FPS;
	linear_control.flag=CNT_UP_FLAG;
	linear_control.x_pix_len=640;
	linear_control.start=linear_control_start;
}

void Bounce_nonlinear_control_init()
{
	Bounce_nonlinear_control.next=Bounce_nonlinear_control_next;
	Bounce_nonlinear_control.cnt=0;
	Bounce_nonlinear_control.time=TIME;
	Bounce_nonlinear_control.cnt_max=Bounce_nonlinear_control.time*FPS;
	Bounce_nonlinear_control.flag=CNT_UP_FLAG;
	Bounce_nonlinear_control.x_pix_len=640;
	Bounce_nonlinear_control.start=Bounce_nonlinear_control_start;
}

void Circ_nonlinear_control_init()
{
	Circ_nonlinear_control.next=Circ_nonlinear_control_next;
	Circ_nonlinear_control.cnt=0;
	Circ_nonlinear_control.time=TIME;
	Circ_nonlinear_control.cnt_max=Circ_nonlinear_control.time*FPS;
	Circ_nonlinear_control.flag=CNT_UP_FLAG;
	Circ_nonlinear_control.x_pix_len=640;
	Circ_nonlinear_control.start=Circ_nonlinear_control_start;
}

void Quint_nonlinear_control_init()
{
	Quint_nonlinear_control.next=Quint_nonlinear_control_next;
	Quint_nonlinear_control.cnt=0;
	Quint_nonlinear_control.time=TIME;
	Quint_nonlinear_control.cnt_max=Quint_nonlinear_control.time*FPS;
	Quint_nonlinear_control.flag=CNT_UP_FLAG;
	Quint_nonlinear_control.x_pix_len=640;
	Quint_nonlinear_control.start=Quint_nonlinear_control_start;
}

int32_t cal_y_pic(int32_t x_pic)
{
		int32_t temp_y;
	if (160<=x_pic && x_pic<=640)
	{
		temp_y= (x_pic*3)>>2;
	}
	else if (x_pic<=1920)
	{
		temp_y= 480+(((x_pic-640)*15)>>5);
	}
	else if(x_pic<=2560)
	{
		temp_y=1080+(((x_pic-1920)*9)>>4);
	}
	else if(x_pic<=3840)
	{
		temp_y=1440+(((x_pic-2560)*9)>>4);
	}
	else
	{
		return 480;
	}
	return temp_y;
	
}

uint8_t send_flag=0;//不同时发送两次

void send_uart(uint16_t x_value,uint16_t y_value)
{
	if(x_value<=min_x_pic)
	{
		x_value=min_x_pic;
	}
	else if(x_value >=max_x_pic)
	{
		x_value=max_x_pic;
	}
	
	if(y_value<=min_y_pic)
	{
		y_value=min_y_pic;
	}
	else if(y_value >=max_y_pic)
	{
		y_value=max_y_pic;
	}
	
	unsigned char send1=(x_value>>8) & 0xFF;
	unsigned char send2=x_value & 0xFF;
	unsigned char send3=(y_value>>8) & 0xFF;
	unsigned char send4=y_value & 0xFF;	
	printf("%c%c",170,85);//10101010 01010101
	printf("%c%c%c%c",send1,send2,send3,send4);
	send_flag=1;
	//printf("value:%d\n",value);
}

void send_uart_control_vid_format(uint8_t vid_format_)
{
	printf("%c%c%c%c",170,85,207,vid_format_);//10101010 01010101 11001111//AA 55 CF
	send_flag=1;
}

void send_uart_control_algorithm(uint8_t algorithm_)
{
	
	printf("%c%c%c%c",170,85,63,algorithm_);//10101010 01010101 00111111//AA 55 3F
	send_flag=1;
}

void send_uart_a(uint16_t a_slider_val_)
{
	uint16_t a_val=a_slider_val_;
	if (a_val==0)
	{
		a_val=511;
	}
	else
	{
		a_val=((400-a_val)<<9)/400;
	}
	uint8_t send1=(a_val>>8) & 0xFF;
	uint8_t send2=a_val & 0xFF;
	
	//printf("a= %d \n",a_val);
	printf("%c%c%c",170,85,175);//10101010 01010101 10101111 // AA 55 AF
	printf("%c%c",send1,send2);
	send_flag=1;
}
	
void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef *htim)
{
	
	if (htim->Instance == TIM1) // //调用频率120Hz
  {
		send_flag=0;
		
//		if(last_vid_format !=cur_vid_format )
//		{
//			last_vid_format =cur_vid_format;
//			send_uart_control_vid_format(last_vid_format);
//		}
//		
		if(last_algorithm !=cur_algorithm && send_flag==0)
		{
			last_algorithm =cur_algorithm;
			send_uart_control_algorithm(last_algorithm);
		}
		
		if(last_a_slider_val!=cur_a_slider_val && send_flag==0)
		{
			last_a_slider_val=cur_a_slider_val;
			send_uart_a(cur_a_slider_val);
		}
		
		if (mode == HAND_SET_MODE )
		{
			int32_t x_slider_value = lv_slider_get_value(guider_ui.screen_slider_x_pix);
			int32_t y_slider_value = lv_slider_get_value(guider_ui.screen_slider_y_pix);
			uint8_t slider_value_changed_flag=0;
			if(x_slider_value!=last_x_value || y_slider_value!=last_y_value)
			{
				last_x_value=x_slider_value;
				last_y_value=y_slider_value;
				if(send_flag==0)
				{
					send_uart(last_x_value,last_y_value);
				}
			}
		}
		else if(mode == DEMO_LINEAR_MODE)
		{
			linear_control.next(&linear_control);
			if(linear_control.x_pix_len!=last_x_value)
			{
				last_x_value=linear_control.x_pix_len;
				last_y_value=cal_y_pic(last_x_value);
				if(send_flag==0)
				{
					send_uart(last_x_value,last_y_value);
				}
				lv_label_set_text_fmt(guider_ui.screen_label_x_pix,"%d",last_x_value);
				lv_label_set_text_fmt(guider_ui.screen_label_y_pix,"%d",last_y_value);
				lv_slider_set_value(guider_ui.screen_slider_x_pix,last_x_value,LV_ANIM_OFF);
				lv_slider_set_value(guider_ui.screen_slider_y_pix,last_y_value,LV_ANIM_OFF);
			}
		}
		else if(mode == DEMO_NONLINEAR_MODE)
		{
			Cur_nonlinear_control->next(Cur_nonlinear_control);
			if(Cur_nonlinear_control->x_pix_len!=last_x_value)
			{
				last_x_value=Cur_nonlinear_control->x_pix_len;
				last_y_value=cal_y_pic(last_x_value);
				if(send_flag==0)
				{
					send_uart(last_x_value,last_y_value);
				}
				lv_label_set_text_fmt(guider_ui.screen_label_x_pix,"%d",last_x_value);
				lv_label_set_text_fmt(guider_ui.screen_label_y_pix,"%d",last_y_value);
				lv_slider_set_value(guider_ui.screen_slider_x_pix,last_x_value,LV_ANIM_OFF);
				lv_slider_set_value(guider_ui.screen_slider_y_pix,last_y_value,LV_ANIM_OFF);
			}
		}
		
  }
	
	if(htim->Instance == TIM2)////调用频率10Hz
	{
		if(pressing_cnt<PRESSING_CNT_MAX)
		{
			//printf("pressing_cnt:%d\n",pressing_cnt);
			pressing_cnt++;
			
		}
		
		if(pressed_cnt<PRESSED_CNT_MAX)
		{
			//printf("pressed_cnt:%d\n",pressed_cnt);
			pressed_cnt++;
		}
		///printf("TIM2\n");
	}
}

void slider_x_value_changed_callback()
{
	int32_t slider_value = lv_slider_get_value(guider_ui.screen_slider_x_pix);
	lv_label_set_text_fmt(guider_ui.screen_label_x_pix,"%d",slider_value);
}

void slider_y_value_changed_callback()
{
	int32_t slider_value = lv_slider_get_value(guider_ui.screen_slider_y_pix);
	lv_label_set_text_fmt(guider_ui.screen_label_y_pix,"%d",slider_value);
}

void slider_pressed_callback()
{
	mode =HAND_SET_MODE;
	//printf("set hand");
}

void btn_linear_demo_callback()
{
	mode = DEMO_LINEAR_MODE;
	linear_control_start();
	//printf("set LINEAR");
}

void btn_nonlinear_demo_callback()
{
	mode = DEMO_NONLINEAR_MODE;
	restart_all();
	//Bounce_nonlinear_control_start();
	//Circ_nonlinear_control_start();
	//Quint_nonlinear_control_start();
	//printf("set NONLINEAR");
}

void btn_hand_set_callback()
{
	mode =HAND_SET_MODE;
	//printf("set hand");
}

uint16_t temp_val;

void btn_x_plus_callback()
{
		if( pressed_cnt>=PRESSED_CNT_MAX)
	{
	temp_val=last_x_value+1;
	if(temp_val>=max_x_pic)
	{
		temp_val=max_x_pic;
	}
	
	lv_label_set_text_fmt(guider_ui.screen_label_x_pix,"%d",temp_val);
	lv_slider_set_value(guider_ui.screen_slider_x_pix,temp_val,LV_ANIM_OFF);
}
}

void btn_x_minus_callback()
{
		if( pressed_cnt>=PRESSED_CNT_MAX)
	{
	temp_val=last_x_value-1;
	if(temp_val<=min_x_pic)
	{
		temp_val=min_x_pic;
	}
	
	lv_label_set_text_fmt(guider_ui.screen_label_x_pix,"%d",temp_val);
	lv_slider_set_value(guider_ui.screen_slider_x_pix,temp_val,LV_ANIM_OFF);
}
}

void btn_y_plus_callback()
{
		if( pressed_cnt>=PRESSED_CNT_MAX)
	{
	temp_val=last_y_value+1;
	if(temp_val>=max_y_pic)
	{
		temp_val=max_y_pic;
	}
	
	lv_label_set_text_fmt(guider_ui.screen_label_y_pix,"%d",temp_val);
	lv_slider_set_value(guider_ui.screen_slider_y_pix,temp_val,LV_ANIM_OFF);
	}
}
void btn_y_minus_callback()
{	
	if( pressed_cnt>=PRESSED_CNT_MAX)
	{
	temp_val=last_y_value-1;
	if(temp_val<=min_y_pic)
	{
		temp_val=min_y_pic;
	}
	
	lv_label_set_text_fmt(guider_ui.screen_label_y_pix,"%d",temp_val);
	lv_slider_set_value(guider_ui.screen_slider_y_pix,temp_val,LV_ANIM_OFF);	
	}
}

void btn_x_y_callback()
{
	mode =HAND_SET_MODE;
	if( pressed_cnt>=PRESSED_CNT_MAX)
	{
		pressing_cnt=0;
	}
	pressed_cnt=0;
}

void btn_x_plus_pressing_callback()
{
	if(pressing_cnt>=PRESSING_CNT_MAX)
	{
	temp_val=temp_val+1;
	if(temp_val>=max_x_pic)
	{
		temp_val=max_x_pic;
	}

	lv_label_set_text_fmt(guider_ui.screen_label_x_pix,"%d",temp_val);
	lv_slider_set_value(guider_ui.screen_slider_x_pix,temp_val,LV_ANIM_OFF);
	}
}

void btn_x_minus_pressing_callback()
{
	if(pressing_cnt>=PRESSING_CNT_MAX)
	{
	temp_val=temp_val-1;
	if(temp_val<=min_x_pic)
	{
		temp_val=min_x_pic;
	}

	lv_label_set_text_fmt(guider_ui.screen_label_x_pix,"%d",temp_val);
	lv_slider_set_value(guider_ui.screen_slider_x_pix,temp_val,LV_ANIM_OFF);
	}
}

void btn_y_plus_pressing_callback()
{
	if(pressing_cnt>=PRESSING_CNT_MAX)
	{
	temp_val=temp_val+1;
	if(temp_val>=max_y_pic)
	{
		temp_val=max_y_pic;
	}

	lv_label_set_text_fmt(guider_ui.screen_label_y_pix,"%d",temp_val);
	lv_slider_set_value(guider_ui.screen_slider_y_pix,temp_val,LV_ANIM_OFF);
	}
}

void btn_y_minus_pressing_callback()
{
	if(pressing_cnt>=PRESSING_CNT_MAX)
	{
	temp_val=temp_val-1;
	if(temp_val<=min_y_pic)
	{
		temp_val=min_y_pic;
	}

	lv_label_set_text_fmt(guider_ui.screen_label_y_pix,"%d",temp_val);
	lv_slider_set_value(guider_ui.screen_slider_y_pix,temp_val,LV_ANIM_OFF);	
	}
}
void btn_x_y_pressing_callback()
{
	
}

void ddlist_max_value_changed_callback()
{
	uint16_t id = lv_dropdown_get_selected(guider_ui.screen_ddlist_max);
		if(id==0)
	{
		max_x_pic=1920;
		max_y_pic=1080;
	}
	else if(id ==1)
	{
		max_x_pic=2560;
		max_y_pic=1440;
	}
	else if(id ==2)
	{
		max_x_pic=3840;
		max_y_pic=2160;
	}
	if(last_x_value>max_x_pic || last_y_value>max_y_pic)
	{
		last_x_value=max_x_pic;
		lv_slider_set_value(guider_ui.screen_slider_x_pix,last_x_value,LV_ANIM_OFF);
		lv_label_set_text_fmt(guider_ui.screen_label_x_pix,"%d",last_x_value);
		
		last_y_value=max_y_pic;
		lv_slider_set_value(guider_ui.screen_slider_y_pix,last_y_value,LV_ANIM_OFF);
		lv_label_set_text_fmt(guider_ui.screen_label_y_pix,"%d",last_y_value);
		
		send_uart(last_x_value,last_y_value);
	}
	
	restart_all();
	lv_slider_set_range(guider_ui.screen_slider_x_pix, min_x_pic, max_x_pic);
	lv_slider_set_range(guider_ui.screen_slider_y_pix, min_y_pic, max_y_pic);
}
void ddlist_min_value_changed_callback()
{
	uint16_t id = lv_dropdown_get_selected(guider_ui.screen_ddlist_min);
	if(id==0)
	{
		min_x_pic=640;
		min_y_pic=480;
	}
	else if(id ==1)
	{
		min_x_pic=320;
		min_y_pic=240;
	}
	else if(id ==2)
	{
		min_x_pic=160;
		min_y_pic=120;
	}
	
	if (last_x_value<min_x_pic || last_y_value<min_y_pic)
	{

		last_x_value=min_x_pic;
		lv_slider_set_value(guider_ui.screen_slider_x_pix,last_x_value,LV_ANIM_OFF);
		lv_label_set_text_fmt(guider_ui.screen_label_x_pix,"%d",last_x_value);
		
		last_y_value=min_y_pic;
		lv_slider_set_value(guider_ui.screen_slider_y_pix,last_y_value,LV_ANIM_OFF);
		lv_label_set_text_fmt(guider_ui.screen_label_y_pix,"%d",last_y_value);
		
		send_uart(last_x_value,last_y_value);
	}
	
	restart_all();
	lv_slider_set_range(guider_ui.screen_slider_x_pix, min_x_pic, max_x_pic);
	lv_slider_set_range(guider_ui.screen_slider_y_pix, min_y_pic, max_y_pic);
}

void ddlist_mode_value_changed_callback()
{
	uint16_t id = lv_dropdown_get_selected(guider_ui.screen_ddlist_nonlinear);
	//printf("id:%d",id);
	if (id == BONCE_MODE)
	{
		nonlinear_mode = BONCE_MODE;
		Cur_nonlinear_control = &Bounce_nonlinear_control;	
	}
	else if(id == CIRC_MODE)
	{
		nonlinear_mode = CIRC_MODE;
		Cur_nonlinear_control = &Circ_nonlinear_control;	
	}
	else if (id == QUINT_MODE)
	{
		nonlinear_mode = QUINT_MODE;
		Cur_nonlinear_control = &Quint_nonlinear_control;	
	}
	
	if(last_nonlinear_mode!=nonlinear_mode)
	{
		last_nonlinear_mode=nonlinear_mode;
		Cur_nonlinear_control->start();
	}
}

void ddlist_vid_format_value_change_callback()
{
	uint16_t selected_id = lv_dropdown_get_selected(guider_ui.screen_ddlist_vid_format);
	cur_vid_format=selected_id;
	if(cur_vid_format==VID_FORMAT_1080P)
	{
		lv_dropdown_set_selected(guider_ui.screen_ddlist_max,0);
		lv_dropdown_set_options(guider_ui.screen_ddlist_max, " 1920\n 2560");
		lv_dropdown_set_options(guider_ui.screen_ddlist_min, "   640\n   320\n   160");
		//max_y_pic=1080;
		//max_x_pic=1920;
		ddlist_max_value_changed_callback();
	}
	else if(cur_vid_format==VID_FORMAT_4K)
	{
		lv_dropdown_set_options(guider_ui.screen_ddlist_max, " 1920\n 2560");
		lv_dropdown_set_selected(guider_ui.screen_ddlist_min,0);
		lv_dropdown_set_options(guider_ui.screen_ddlist_min, "   640\n   320\n   160");
		
		ddlist_min_value_changed_callback();
	}
	
}

void ddlist_algorithm_value_change_callback()
{
	uint16_t selected_id = lv_dropdown_get_selected(guider_ui.screen_ddlist_algorithm);
	cur_algorithm=selected_id;	
}

void slider_a_value_changed_callback()
{
	cur_a_slider_val= lv_slider_get_value(guider_ui.screen_slider_a);
	float a_val=cur_a_slider_val;
	a_val= -(400.0-a_val)/200.0;
	char temp_str[10]={0};
	sprintf(temp_str,"%1.3f",a_val);
	lv_label_set_text(guider_ui.screen_label_a_value,temp_str);
}
void img_click_callback()
{
	if(cur_algorithm==ALGORITHM_BCI)
	{
		lv_obj_clear_flag(guider_ui.screen_Alpha_cont, LV_OBJ_FLAG_HIDDEN);
	}
}

void app_init()
{

	lv_init();                         
  lv_port_disp_init();               
  lv_port_indev_init();              
	
	setup_ui(&guider_ui);
	events_init(&guider_ui);
	
	linear_control_init();
	Bounce_nonlinear_control_init();
	Circ_nonlinear_control_init();
	Quint_nonlinear_control_init();
	
	HAL_TIM_Base_Start_IT(&htim1);
	HAL_TIM_Base_Start_IT(&htim2);
}

void app_mainloop()
{
	lv_task_handler();
}













//#define SDRAM_BANK_ADDR     ((uint32_t)0xC0000000) 				// FMC SDRAM 数据基地址
//#define SDRAM_Size 32*1024*1024  //32M字节
//uint8_t SDRAM_Test(void)
//{
//	uint32_t i = 0;			// 计数变量
//	uint16_t ReadData = 0; 	// 读取到的数据
//	uint8_t  ReadData_8b;

//	uint32_t ExecutionTime_Begin;		// 开始时间
//	uint32_t ExecutionTime_End;		// 结束时间
//	uint32_t ExecutionTime;				// 执行时间	
//	float    ExecutionSpeed;			// 执行速度
//	
//	printf("\r\n*****************************************************************************************************\r\n");		
//	printf("\r\n进行速度测试>>>\r\n");

//// 写入 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

//	ExecutionTime_Begin 	= HAL_GetTick();	// 获取 systick 当前时间，单位ms
//	
//	for (i = 0; i < SDRAM_Size/2; i++)
//	{
// 		*(__IO uint16_t*) (SDRAM_BANK_ADDR + 2*i) = (uint16_t)i;		// 写入数据
//	}
//	ExecutionTime_End		= HAL_GetTick();											// 获取 systick 当前时间，单位ms
//	ExecutionTime  = ExecutionTime_End - ExecutionTime_Begin; 				// 计算擦除时间，单位ms
//	ExecutionSpeed = (float)SDRAM_Size /1024/1024 /ExecutionTime*1000 ; 	// 计算速度，单位 MB/S	
//	
//	printf("\r\n以16位数据宽度写入数据，大小：%d MB，耗时: %d ms, 写入速度：%.2f MB/s\r\n",SDRAM_Size/1024/1024,ExecutionTime,ExecutionSpeed);

//// 读取	>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 

//	ExecutionTime_Begin 	= HAL_GetTick();	// 获取 systick 当前时间，单位ms
//	
//	for(i = 0; i < SDRAM_Size/2;i++ )
//	{
//		ReadData = *(__IO uint16_t*)(SDRAM_BANK_ADDR + 2 * i );  // 从SDRAM读出数据	
//	}
//	ExecutionTime_End		= HAL_GetTick();											// 获取 systick 当前时间，单位ms
//	ExecutionTime  = ExecutionTime_End - ExecutionTime_Begin; 				// 计算擦除时间，单位ms
//	ExecutionSpeed = (float)SDRAM_Size /1024/1024 /ExecutionTime*1000 ; 	// 计算速度，单位 MB/S	
//	
//	printf("\r\n读取数据完毕，大小：%d MB，耗时: %d ms, 读取速度：%.2f MB/s\r\n",SDRAM_Size/1024/1024,ExecutionTime,ExecutionSpeed);
//	
//// 数据校验 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>   
//		
//	printf("\r\n*****************************************************************************************************\r\n");		
//	printf("\r\n进行数据校验>>>\r\n");
//	
//	for(i = 0; i < SDRAM_Size/2;i++ )
//	{
//		ReadData = *(__IO uint16_t*)(SDRAM_BANK_ADDR + 2 * i );  // 从SDRAM读出数据	
//		if( ReadData != (uint16_t)i )      //检测数据，若不相等，跳出函数,返回检测失败结果。
//		{
//			printf("\r\nSDRAM测试失败！！\r\n");
//			return ERROR;	 // 返回失败标志
//		}
//	}
//	
//	printf("\r\n16位数据宽度读写通过，以8位数据宽度写入数据\r\n");
//	for (i = 0; i < 255; i++)
//	{
// 		*(__IO uint8_t*) (SDRAM_BANK_ADDR + i) =  (uint8_t)i;
//	}	
//	printf("写入完毕，读取数据并比较...\r\n");
//	for (i = 0; i < 255; i++)
//	{
//		ReadData_8b = *(__IO uint8_t*) (SDRAM_BANK_ADDR + i);
//		if( ReadData_8b != (uint8_t)i )      //检测数据，若不相等，跳出函数,返回检测失败结果。
//		{
//			printf("8位数据宽度读写测试失败！！\r\n");
//			printf("请检查NBL0和NBL1的连接\r\n");	
//			return ERROR;	 // 返回失败标志
//		}
//	}		
//	printf("8位数据宽度读写通过\r\n");
//	printf("SDRAM读写测试通过，系统正常\r\n");
//	return SUCCESS;	 // 返回成功标志
//}

