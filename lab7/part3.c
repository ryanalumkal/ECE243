#include <stdlib.h>
#include <stdbool.h>

volatile int pixel_buffer_start; // global variable
short int Buffer1[240][512]; // 240 rows, 512 (320 + padding) columns
short int Buffer2[240][512];

// code for subroutines (not shown)

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

void wait_for_vsync(){
	volatile int * pixel_ctrl_ptr = (int *)0xFF203020;
	
	*pixel_ctrl_ptr = 1;
	
	int status = *(pixel_ctrl_ptr + 3);
	
	while((status & 0x01) !=0){
		status = *(pixel_ctrl_ptr + 3);
	}
}

void draw(int num_boxes, int x_box[], int y_box[], int color_box[]){
	
	for (int i = 0; i < num_boxes; i++){
		draw_line(x_box[i], y_box[i], x_box[i], y_box[i], color_box[i]);
		draw_line(x_box[i], y_box[i], x_box[(i+1)%(num_boxes)], y_box[(i+1)%(num_boxes)], color_box[i]);
	}
}

void shift_arr(int arr[], int num_boxes) {
    for (int i = 0; i < num_boxes; i++) {
        arr[i] = arr[i + num_boxes];
    }
}
	
int main(void)
{
    volatile int * pixel_ctrl_ptr = (int *)0xFF203020;
    // declare other variables(not shown)
	int num_boxes = 8;
	int x_box[num_boxes];
	int y_box[num_boxes];
	int dx_box[num_boxes];
	int dy_box[num_boxes];
	int color_box[num_boxes];
	unsigned int colors[10] = {0xFFFF, 0xFFE0, 0xF800, 0x07E0, 0x001F, 0xF81F, 0x07FF,
        0xFD20, 0xF95F, 0xA01E};
	
	int two_frames_ago_x_box[num_boxes*2];
	int two_frames_ago_y_box[num_boxes*2];
	
	// initialize location and direction of rectangles(not shown)
	for (int i = 0; i < num_boxes; i++){
		dx_box[i] = ((rand()%2)*2)-1;
		dy_box[i] = ((rand()%2)*2)-1;
		
		x_box[i] = rand()%320;
		y_box[i] = rand()%240;
					
		color_box[i] = colors[rand()%10];
		
		two_frames_ago_x_box[i] = x_box[i];
		two_frames_ago_x_box[i+num_boxes] = x_box[i];
		two_frames_ago_y_box[i] = y_box[i];
		two_frames_ago_y_box[i+num_boxes] = y_box[i];
	}
	
    /* set front pixel buffer to Buffer 1 */
    *(pixel_ctrl_ptr + 1) = (int) &Buffer1; // first store the address in the  back buffer
    /* now, swap the front/back buffers, to set the front buffer location */
    wait_for_vsync();
    /* initialize a pointer to the pixel buffer, used by drawing functions */
    pixel_buffer_start = *pixel_ctrl_ptr;
    clear_screen(); // pixel_buffer_start points to the pixel buffer

    /* set back pixel buffer to Buffer 2 */
    *(pixel_ctrl_ptr + 1) = (int) &Buffer2;
    pixel_buffer_start = *(pixel_ctrl_ptr + 1); // we draw on the back buffer
    clear_screen(); // pixel_buffer_start points to the pixel buffer

    while (1){   
		
        // code for drawing the boxes and lines (not shown) + /* Erase any boxes and lines that were drawn in the last iteration */
		clear_screen();
		//draw(num_boxes, two_frames_ago_x_box, two_frames_ago_y_box, 0x0000);
		
		draw(num_boxes, x_box, y_box, color_box);
		
        // code for updating the locations of boxes (not shown)
		for (int i = 0; i < num_boxes; i++){
			x_box[i] += dx_box[i];
			y_box[i] += dy_box[i];
			
			if (x_box[i] >= 320 || x_box[i] <=0){
				dx_box[i] = -dx_box[i];
			}
			
			if (y_box[i] >= 240 || y_box[i] <=0){
				dy_box[i] = -dy_box[i];
			}
			
			two_frames_ago_x_box[i+num_boxes] = x_box[i];
			two_frames_ago_y_box[i+num_boxes] = y_box[i];
		}
		
        wait_for_vsync(); // swap front and back buffers on VGA vertical sync
		
		shift_arr(two_frames_ago_x_box, num_boxes);
		shift_arr(two_frames_ago_y_box, num_boxes);
		
        pixel_buffer_start = *(pixel_ctrl_ptr + 1); // new back buffer
    }
}


