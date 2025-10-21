function [img2] = Neighborhood_Int(img1,row_num1,col_num1,row_num2,col_num2)

% 扩展图像是为了后面插值时避免越界
img1 = [img1;img1(row_num1,:)];    %   底部扩展一行，直接拷贝最后一行
img1 = [img1,img1(:,col_num1)];    %   右侧扩展一列，直接拷贝最后一列

img1 = double(img1);

x_ratio = floor(col_num1/col_num2*2^16)/2^16;
y_ratio = floor(row_num1/row_num2*2^16)/2^16;

for i = 1 : row_num2
    y  = fix((i-1)*y_ratio) + 1;
    dv = (i-1)*y_ratio - fix((i-1)*y_ratio);
    if (dv<1-dv) 
        A  = [1,0];
    else
        A  = [0,1];
    end
    for j = 1 : col_num2
        x  = fix((j-1)*x_ratio) + 1;
        du = (j-1)*x_ratio - fix((j-1)*x_ratio);
        if (du<1-du) 
            C  = [1;0];
        else
            C  = [0;1];
        end
        B  = img1(y:y+1,x:x+1);
        img2(i,j) = A*B*C;
    end
end
img2 = uint8(img2);
