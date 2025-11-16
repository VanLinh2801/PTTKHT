package model;

import java.time.LocalDate;

public class SparePart {
    private Integer id;
    private String name;
    private Double price;
    private String description;
    private Integer availableQuantity;
    private String manufacturer;
    private LocalDate warrantyPeriod;

    public SparePart() {}

    public SparePart(String name, Double price, String description, Integer availableQuantity, 
                     String manufacturer, LocalDate warrantyPeriod) {
        this.name = name;
        this.price = price;
        this.description = description;
        this.availableQuantity = availableQuantity;
        this.manufacturer = manufacturer;
        this.warrantyPeriod = warrantyPeriod;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getAvailableQuantity() {
        return availableQuantity;
    }

    public void setAvailableQuantity(Integer availableQuantity) {
        this.availableQuantity = availableQuantity;
    }

    public String getManufacturer() {
        return manufacturer;
    }

    public void setManufacturer(String manufacturer) {
        this.manufacturer = manufacturer;
    }

    public LocalDate getWarrantyPeriod() {
        return warrantyPeriod;
    }

    public void setWarrantyPeriod(LocalDate warrantyPeriod) {
        this.warrantyPeriod = warrantyPeriod;
    }

    @Override
    public String toString() {
        return "SparePart{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", price=" + price +
                ", description='" + description + '\'' +
                ", availableQuantity=" + availableQuantity +
                ", manufacturer='" + manufacturer + '\'' +
                ", warrantyPeriod=" + warrantyPeriod +
                '}';
    }
}