package model;

import java.time.LocalDate;

public class ImportInvoice {
    private Integer id;
    private LocalDate date;
    private Float totalAmount;
    private String status;
    private Integer warehouseStaffId;
    private Integer supplierId;

    public ImportInvoice() {}

    public ImportInvoice(LocalDate date, Float totalAmount, String status, 
                         Integer warehouseStaffId, Integer supplierId) {
        this.date = date;
        this.totalAmount = totalAmount;
        this.status = status;
        this.warehouseStaffId = warehouseStaffId;
        this.supplierId = supplierId;
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

    public Float getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(Float totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getWarehouseStaffId() {
        return warehouseStaffId;
    }

    public void setWarehouseStaffId(Integer warehouseStaffId) {
        this.warehouseStaffId = warehouseStaffId;
    }

    public Integer getSupplierId() {
        return supplierId;
    }

    public void setSupplierId(Integer supplierId) {
        this.supplierId = supplierId;
    }

    @Override
    public String toString() {
        return "ImportInvoice{" +
                "id=" + id +
                ", date=" + date +
                ", totalAmount=" + totalAmount +
                ", status='" + status + '\'' +
                ", warehouseStaffId=" + warehouseStaffId +
                ", supplierId=" + supplierId +
                '}';
    }
}
