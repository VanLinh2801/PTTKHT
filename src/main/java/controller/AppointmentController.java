
package controller;

import dao.AppointmentDao;
import model.Appointment;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/appointment")
public class AppointmentController extends HttpServlet {
    
    private AppointmentDao appointmentDao = new AppointmentDao();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("select".equals(action) || action == null) {

            selectDate(request, response);
        } else {

            response.sendRedirect("customer-home.jsp");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("create".equals(action) || action == null) {

            createAppointment(request, response);
        } else {
            response.sendRedirect("customer-home.jsp");
        }
    }

    private void selectDate(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String dateParam = request.getParameter("date");
        if (dateParam != null && !dateParam.isEmpty()) {
            try {
                LocalDate selectedDate = LocalDate.parse(dateParam);
                LocalDate today = LocalDate.now();

                if (selectedDate.isBefore(today)) {
                    request.setAttribute("error", "Không thể đặt lịch cho ngày trong quá khứ. Vui lòng chọn ngày từ hôm nay trở đi.");
                }

                else if (selectedDate.getDayOfWeek() == java.time.DayOfWeek.SUNDAY) {
                    request.setAttribute("selectedDate", selectedDate);
                    request.setAttribute("isSunday", true);
                    request.setAttribute("sundayMessage", "🏖️ Chủ nhật chúng tôi nghỉ làm việc. Vui lòng chọn ngày khác.");
                } else {

                    List<TimeSlot> timeSlots = generateTimeSlotsForDate(selectedDate);

                    LocalTime currentTime = LocalTime.now();
                    boolean isToday = selectedDate.equals(today);
                    
                    HttpSession session = request.getSession();
                    User user = (User) session.getAttribute("user");

                    List<SlotWithAvailability> slotsWithAvailability = new ArrayList<>();
                    for (TimeSlot timeSlot : timeSlots) {
                        boolean hasExistingAppointment = appointmentDao.hasExistingAppointment(user.getId(), selectedDate, timeSlot.getStartAt());

                        boolean isPast = isToday && timeSlot.getStartAt().isBefore(currentTime);

                        boolean isAvailable = !hasExistingAppointment && !isPast;
                        
                        slotsWithAvailability.add(new SlotWithAvailability(timeSlot.getStartAt(), timeSlot.getEndAt(), isAvailable, hasExistingAppointment, isPast));
                    }
                    
                    request.setAttribute("selectedDate", selectedDate);
                    request.setAttribute("slots", slotsWithAvailability);
                }
            } catch (Exception e) {
                request.setAttribute("error", "Ngày không hợp lệ. Vui lòng chọn ngày đúng định dạng.");
                e.printStackTrace();
            }
        }
        
        request.getRequestDispatcher("select-date.jsp").forward(request, response);
    }

    private void createAppointment(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        String slotTimeStr = request.getParameter("slotTime");
        String note = request.getParameter("note");
        String dateStr = request.getParameter("date");
        
        if (slotTimeStr != null && !slotTimeStr.isEmpty() && dateStr != null && !dateStr.isEmpty()) {
            try {
                LocalTime appointmentTime = LocalTime.parse(slotTimeStr);
                LocalDate appointmentDate = LocalDate.parse(dateStr);
                LocalDate today = LocalDate.now();
                LocalTime currentTime = LocalTime.now();

                if (appointmentDate.equals(today) && appointmentTime.isBefore(currentTime)) {
                    request.setAttribute("error", "Không thể đặt lịch cho khung giờ trong quá khứ");
                }

                else if (appointmentDao.hasExistingAppointment(user.getId(), appointmentDate, appointmentTime)) {
                    request.setAttribute("error", "Bạn đã có lịch hẹn trong khung giờ này rồi");
                } else {

                    Appointment appointment = new Appointment();
                    appointment.setAppointmentDate(appointmentDate);
                    appointment.setAppointmentTime(appointmentTime);
                    appointment.setStatus("BOOKED");
                    appointment.setNote(note);
                    appointment.setCustomerId(user.getId());
                    
                    if (appointmentDao.createAppointment(appointment)) {
                        request.setAttribute("success", "Đặt lịch thành công!");
                    } else {
                        request.setAttribute("error", "Có lỗi xảy ra khi đặt lịch");
                    }
                }
            } catch (Exception e) {
                request.setAttribute("error", "Dữ liệu không hợp lệ");
                e.printStackTrace();
            }
        } else {
            request.setAttribute("error", "Vui lòng chọn slot và ngày");
        }

        selectDate(request, response);
    }

    private static class TimeSlot {
        private LocalTime startAt;
        private LocalTime endAt;
        
        public TimeSlot(LocalTime startAt, LocalTime endAt) {
            this.startAt = startAt;
            this.endAt = endAt;
        }
        
        public LocalTime getStartAt() { return startAt; }
        public LocalTime getEndAt() { return endAt; }
    }

    private List<TimeSlot> generateTimeSlotsForDate(LocalDate date) {
        List<TimeSlot> timeSlots = new ArrayList<>();
        DayOfWeek dayOfWeek = date.getDayOfWeek();
        
        if (dayOfWeek == DayOfWeek.SATURDAY) {

            for (int hour = 7; hour < 12; hour++) {
                timeSlots.add(new TimeSlot(LocalTime.of(hour, 0), LocalTime.of(hour + 1, 0)));
            }
        } else {

            for (int hour = 7; hour < 12; hour++) {
                timeSlots.add(new TimeSlot(LocalTime.of(hour, 0), LocalTime.of(hour + 1, 0)));
            }
            for (int hour = 13; hour < 18; hour++) {
                timeSlots.add(new TimeSlot(LocalTime.of(hour, 0), LocalTime.of(hour + 1, 0)));
            }
        }
        
        return timeSlots;
    }

    public static class SlotWithAvailability {
        private LocalTime startAt;
        private LocalTime endAt;
        private boolean isAvailable;
        private boolean hasExistingAppointment;
        private boolean isPast;
        
        public SlotWithAvailability(LocalTime startAt, LocalTime endAt, boolean isAvailable, boolean hasExistingAppointment, boolean isPast) {
            this.startAt = startAt;
            this.endAt = endAt;
            this.isAvailable = isAvailable;
            this.hasExistingAppointment = hasExistingAppointment;
            this.isPast = isPast;
        }
        
        public LocalTime getStartAt() { return startAt; }
        public LocalTime getEndAt() { return endAt; }
        public boolean isAvailable() { return isAvailable; }
        public boolean hasExistingAppointment() { return hasExistingAppointment; }
        public boolean isPast() { return isPast; }
    }
}

