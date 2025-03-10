#include <stdlib.h>
#include <stdbool.h>

int pixel_buffer_start; // global variable

// code not shown for clear_screen() and draw_line() subroutines

void plot_pixel(int x, int y, short int line_color)
{
    volatile short int *one_pixel_address;

       	one_pixel_address = pixel_buffer_start + (y << 10) + (x << 1);

        *one_pixel_address = line_color;
}

void clear_screen(){
	
	for (int x = 0; x <= 320; x++){
		for (int y = 0; y  <=240; y++){
			plot_pixel(x, y, 0x0);
			}
	}
}

void swap(int *n0, int *n1){
	int temp = *n0;
	*n0 = *n1;
	*n1 = temp;
}

void draw_line(int x0, int y0, int x1, int y1, int line_color){
	bool is_steep = abs(y1 - y0) > abs(x1 - x0);
	
	if (is_steep) {
		swap(&x0, &y0);
		swap(&x1, &y1);
	}
	if (x0 > x1){
		swap (&x0, &x1);
		swap (&y0, &y1);
	}
	
	int deltax = x1 - x0;
	int deltay = abs(y1 - y0);
	int error = -(deltax / 2);
	int y = y0;
	int y_step;
	if (y0 < y1){
		y_step = 1;
	} else {
		y_step = -1;
	}
	
	for (int x = x0; x <= x1; x++){
		if (is_steep){
			plot_pixel (y, x, line_color);
		} else {
			plot_pixel(x, y, line_color);
		}
		error += deltay;
		if (error > 0){
			y +=y_step;
			error -=deltax;
		}
	}
}

void wait_for_sync(){
	volatile int * pixel_ctrl_ptr = (int *)0xFF203020;
	
	*pixel_ctrl_ptr = 1;
	
	int status = *(pixel_ctrl_ptr + 3);
	
	while((status & 0x01) !=0){
		status = *(pixel_ctrl_ptr + 3);
	}
}

int main(void)
{
    volatile int * pixel_ctrl_ptr = (int *)0xFF203020;
    /* Read location of the pixel buffer from the pixel buffer controller */
    pixel_buffer_start = *pixel_ctrl_ptr;

    clear_screen();
	int y = 0;
	int x1 = 120;
	int x2 = 200;
	int deltay = 1;
	
	while(1){
    	draw_line(x1, y, x2, y, 0xFFFF);   // this line is white
		wait_for_sync();
		draw_line(x1, y, x2, y, 0x0000);   // draws black line over white, clearing it
		y+=deltay;
		if (y >=240|| y <=0){
			deltay = -deltay;
		}			
	}
	return 0;
}

