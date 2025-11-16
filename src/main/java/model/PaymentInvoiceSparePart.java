package model;

public class PaymentInvoiceSparePart {
    private Integer id;
    private Integer quantity;
    private Float unitPrice;
    private Integer paymentInvoiceId;
    private Integer sparePartId;

    public PaymentInvoiceSparePart() {}

    public PaymentInvoiceSparePart(Integer quantity, Float unitPrice, 
                                  Integer paymentInvoiceId, Integer sparePartId) {
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.paymentInvoiceId = paymentInvoiceId;
        this.sparePartId = sparePartId;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public Float getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(Float unitPrice) {
        this.unitPrice = unitPrice;
    }

    public Integer getPaymentInvoiceId() {
        return paymentInvoiceId;
    }

    public void setPaymentInvoiceId(Integer paymentInvoiceId) {
        this.paymentInvoiceId = paymentInvoiceId;
    }

    public Integer getSparePartId() {
        return sparePartId;
    }

    public void setSparePartId(Integer sparePartId) {
        this.sparePartId = sparePartId;
    }

    @Override
    public String toString() {
        return "PaymentInvoiceSparePart{" +
                "id=" + id +
                ", quantity=" + quantity +
                ", unitPrice=" + unitPrice +
                ", paymentInvoiceId=" + paymentInvoiceId +
                ", sparePartId=" + sparePartId +
                '}';
    }
}
