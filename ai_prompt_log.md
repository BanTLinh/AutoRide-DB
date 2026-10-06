# AI Prompt Log - AutoRide Database Refactoring

## Topic 1: Kiểu dữ liệu tài chính trong MySQL
* Prompt: "So sánh giữa FLOAT, DOUBLE và DECIMAL(10, 2) khi lưu trữ số tiền cọc và phí phạt trong CSDL MySQL. Kiểu nào tránh sai số làm tròn tốt nhất?"
* Ghi nhận kiến thức: DECIMAL(10, 2) lưu trữ số thập phân dưới dạng chuỗi cố định, tránh hoàn toàn sai số làm tròn nhị phân của kiểu FLOAT/DOUBLE.

## Topic 2: Thiết kế quan hệ bảng Inspections
* Prompt: "Nên dùng quan hệ 1-1 hay 1-N giữa bảng Rentals và bảng Inspections trong bài toán cho thuê xe?"
* Ghi nhận kiến thức: Chọn 1-N (rental_id làm khóa ngoại ở Inspections) vì một lượt thuê có thể có nhiều biên bản kiểm tra (lúc nhận xe và lúc trả xe).

## Topic 3: Ràng buộc nghiệp vụ bằng Trigger
* Prompt: "Cách viết MySQL Trigger chặn không cho thêm dữ liệu vào bảng Inspections khi trạng thái hợp đồng đang là BOOKED?"
* Ghi nhận kiến thức: Sử dụng BEFORE INSERT ON Inspections kết hợp với SIGNAL SQLSTATE '45000' để ném exception hủy giao dịch.