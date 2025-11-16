package model;

import java.time.LocalDateTime;

public class UsedService {
    private Integer id;
    private LocalDateTime startAt;
    private LocalDateTime endAt;
    private Integer paymentInvoiceServiceId;
    private Integer technicianId;

    public UsedService() {}

    public UsedService(LocalDateTime startAt, LocalDateTime endAt, 
                       Integer paymentInvoiceServiceId, Integer technicianId) {
        this.startAt = startAt;
        this.endAt = endAt;
        this.paymentInvoiceServiceId = paymentInvoiceServiceId;
        this.technicianId = technicianId;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public LocalDateTime getStartAt() {
        return startAt;
    }

    public void setStartAt(LocalDateTime startAt) {
        this.startAt = startAt;
    }

    public LocalDateTime getEndAt() {
        return endAt;
    }

    public void setEndAt(LocalDateTime endAt) {
        this.endAt = endAt;
    }

    public Integer getPaymentInvoiceServiceId() {
        return paymentInvoiceServiceId;
    }

    public void setPaymentInvoiceServiceId(Integer paymentInvoiceServiceId) {
        this.paymentInvoiceServiceId = paymentInvoiceServiceId;
    }

    public Integer getTechnicianId() {
        return technicianId;
    }

    public void setTechnicianId(Integer technicianId) {
        this.technicianId = technicianId;
    }

    @Override
    public String toString() {
        return "UsedService{" +
                "id=" + id +
                ", startAt=" + startAt +
                ", endAt=" + endAt +
                ", paymentInvoiceServiceId=" + paymentInvoiceServiceId +
                ", technicianId=" + technicianId +
                '}';
    }
}
