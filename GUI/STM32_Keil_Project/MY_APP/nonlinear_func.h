#ifndef __NONLINEAR_H
#define __NONLINEAR_H

#include "arm_math.h"
#include "main.h"
#include "app.h"

float nonlinear_Bounce(float x);
float nonlinear_up_Bounce(float x);
float nonlinear_down_Bounce(float x);
float cal_nonlinear_Bounce_cnt(uint16_t x_pix_len);

float nonlinear_Circ(float x);
float nonlinear_up_Circ(float x);
float nonlinear_down_Circ(float x);
float cal_nonlinear_Circ_cnt(uint16_t x_pix_len);

float nonlinear_Quint(float x);
float cal_nonlinear_Quint_cnt(uint16_t x_pix_len);
float nonlinear_up_Quint(float x);
float nonlinear_down_Quint(float x);

#endif 