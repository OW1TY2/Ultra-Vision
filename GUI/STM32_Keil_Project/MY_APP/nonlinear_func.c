#include "nonlinear_func.h"

float nonlinear_Bounce(float x)
{	
const float n1 = 7.5625;
const float d1 = 2.75;

if (x < 1.0/d1) {
    return n1 * x * x;
} else if (x < 2.0/d1) {
    return n1 * (x - 1.5/d1) * (x - 1.5/d1) + 0.75;
} else if (x < 2.5/d1) {
    return n1 * (x - 2.25/d1) * (x - 2.25/d1) + 0.9375;
} else {
    return n1 * (x - 2.625/d1) * (x - 2.625/d1) + 0.984375;
}	
}

float cal_nonlinear_Bounce_cnt(uint16_t x_pix_len)
{
	float max_x_pic=get_max_x_pic();
  float min_x_pic=get_min_x_pic();
	const float n1 = 7.5625;
	float out;
	arm_sqrt_f32(((float)x_pix_len-min_x_pic)/(max_x_pic-min_x_pic)/n1,&out);
	if (out<=0)
	{
		out=0;
	}
	else if (out>=0.4)
	{
		out=0.4;
	}
	return out/2.0;
}

float nonlinear_up_Bounce(float x)
{
	if(x<=1.0)
	{
		return nonlinear_Bounce(x);
	}
	else 
	{
		return 1.0;
	}
}

float nonlinear_down_Bounce(float x)
{
	if(x>=1.0)
	{
		return (1 - nonlinear_Bounce(2-x));
	}
	else
	{
		return 0;
	}
}

float nonlinear_Circ(float x)
{
	float out;
	arm_sqrt_f32(1 - (x - 1)*(x - 1),&out);
	return out;
}

float cal_nonlinear_Circ_cnt(uint16_t x_pix_len)
{
	float max_x_pic=get_max_x_pic();
  float min_x_pic=get_min_x_pic();
	float out;
	arm_sqrt_f32(1-(((float)x_pix_len-min_x_pic)/(max_x_pic-min_x_pic))*(((float)x_pix_len-min_x_pic)/(max_x_pic-min_x_pic)),&out);
	out = 1.0 - out;
	if (out<=0)
	{
		out=0;
	}
	else if (out>=1)
	{
		out=1;
	}
	return out/2.0;
}

float nonlinear_up_Circ(float x)
{
		if(x<=1.0)
	{
		return nonlinear_Circ(x);
	}
	else 
	{
		return 1.0;
	}
}

float nonlinear_down_Circ(float x)
{
		if(x>=1.0)
	{
		return (1 - nonlinear_Circ(2-x));
	}
	else
	{
		return 0;
	}
}


float nonlinear_Quint(float x)
{
	return 1-powf(1-x,5);
}

float cal_nonlinear_Quint_cnt(uint16_t x_pix_len)
{
	float max_x_pic=get_max_x_pic();
  float min_x_pic=get_min_x_pic();
	return (1-powf(1-((float)x_pix_len-min_x_pic)/(max_x_pic-min_x_pic),0.2))/2.0;
}

float nonlinear_up_Quint(float x)
{
	if(x<=1.0)
	{
		return nonlinear_Quint(x);
	}
	else 
	{
		return 1.0;
	}
}

float nonlinear_down_Quint(float x)
{
	if(x>=1.0)
	{
		return (1 - nonlinear_Quint(2-x));
	}
	else
	{
		return 0;
	}
}