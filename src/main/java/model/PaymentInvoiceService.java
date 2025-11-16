package model;

public class PaymentInvoiceService {
    private Integer id;
    private Float unitPrice;
    private Integer paymentInvoiceId;
    private Integer serviceId;

    public PaymentInvoiceService() {}

    public PaymentInvoiceService(Float unitPrice, 
                                Integer paymentInvoiceId, Integer serviceId) {
        this.unitPrice = unitPrice;
        this.paymentInvoiceId = paymentInvoiceId;
        this.serviceId = serviceId;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
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

    public Integer getServiceId() {
        return serviceId;
    }

    public void setServiceId(Integer serviceId) {
        this.serviceId = serviceId;
    }

    @Override
    public String toString() {
        return "PaymentInvoiceService{" +
                "id=" + id +
                ", unitPrice=" + unitPrice +
                ", paymentInvoiceId=" + paymentInvoiceId +
                ", serviceId=" + serviceId +
                '}';
    }
}
