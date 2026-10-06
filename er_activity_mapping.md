# Phân Tích Tính Toàn Vẹn Của Trường damage_fee Trong CSDL AutoRide

Trong quy trình "Thuê và Trả xe" (Activity Diagram), nhánh rẽ kiểm tra phương tiện phát sinh hai chi phí ngoài hợp đồng: Phí phạt trễ (late_fee) và Phí hư hỏng (damage_fee).

Trường damage_fee trong bảng Rentals đóng vai trò bắt buộc vì các lý do sau:

1. Khép kín dòng tiền nghiệp vụ: Tiền hoàn lại cho khách hàng được xác định bằng công thức: Tiền cọc - Phí trễ - Phí hư hỏng. Thiếu damage_fee, hệ thống không thể hạch toán khoản khấu trừ chi tiết hư hỏng.

2. Tách biệt giữa Mô tả và Giá trị: Bảng Inspections lưu trữ dữ liệu định tính (damage_description), còn damage_fee đại diện cho dữ liệu định lượng (tài chính). Việc lưu riêng giúp kế toán truy vấn báo cáo doanh thu chính xác.

3. Bảo toàn dữ liệu: Đảm bảo hệ thống không thất thoát chi phí sửa chữa xe, loại bỏ hoàn toàn việc nhân viên ghi chép thủ công.