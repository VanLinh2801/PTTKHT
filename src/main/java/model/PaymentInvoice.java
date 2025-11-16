package model;

import java.time.LocalDate;

public class PaymentInvoice {
    private Integer id;
    private LocalDate date;
    private String status;
    private String paymentMethod;
    private Float discount;
    private Integer salesStaffId;
    private Integer customerId;
    private Integer vehicleId;

    public PaymentInvoice() {}

    public PaymentInvoice(LocalDate date, String status, String paymentMethod, 
                          Float discount, Integer salesStaffId, Integer customerId, Integer vehicleId) {
        this.date = date;
        this.status = status;
        this.paymentMethod = paymentMethod;
        this.discount = discount;
        this.salesStaffId = salesStaffId;
        this.customerId = customerId;
        this.vehicleId = vehicleId;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public Float getDiscount() {
        return discount;
    }

    public void setDiscount(Float discount) {
        this.discount = discount;
    }

    public Integer getSalesStaffId() {
        return salesStaffId;
    }

    public void setSalesStaffId(Integer salesStaffId) {
        this.salesStaffId = salesStaffId;
    }

    public Integer getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Integer customerId) {
        this.customerId = customerId;
    }

    public Integer getVehicleId() {
        return vehicleId;
    }

    public void setVehicleId(Integer vehicleId) {
        this.vehicleId = vehicleId;
    }

    @Override
    public String toString() {
        return "PaymentInvoice{" +
                "id=" + id +
                ", date=" + date +
                ", status='" + status + '\'' +
                ", paymentMethod='" + paymentMethod + '\'' +
                ", discount=" + discount +
                ", salesStaffId=" + salesStaffId +
                ", customerId=" + customerId +
                ", vehicleId=" + vehicleId +
                '}';
    }
}
