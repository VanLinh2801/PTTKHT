package model;

public class UsedSparePart {
    private Integer id;
    private Integer quantity;
    private Integer serviceId;
    private Integer sparePartId;

    public UsedSparePart() {}

    public UsedSparePart(Integer quantity, Integer serviceId, Integer sparePartId) {
        this.quantity = quantity;
        this.serviceId = serviceId;
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

    public Integer getServiceId() {
        return serviceId;
    }

    public void setServiceId(Integer serviceId) {
        this.serviceId = serviceId;
    }

    public Integer getSparePartId() {
        return sparePartId;
    }

    public void setSparePartId(Integer sparePartId) {
        this.sparePartId = sparePartId;
    }

    @Override
    public String toString() {
        return "UsedSparePart{" +
                "id=" + id +
                ", quantity=" + quantity +
                ", serviceId=" + serviceId +
                ", sparePartId=" + sparePartId +
                '}';
    }
}

