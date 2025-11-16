package model;

public class Car {
    private Integer id;
    private String licensePlate;
    private String brand;
    private String model;
    private String description;
    private Integer yearOfManufacture;
    private Integer mileage;
    private Integer customerId;

    public Car() {}

    public Car(String licensePlate, String brand, String model, String description, 
                   Integer yearOfManufacture, Integer mileage, Integer customerId) {
        this.licensePlate = licensePlate;
        this.brand = brand;
        this.model = model;
        this.description = description;
        this.yearOfManufacture = yearOfManufacture;
        this.mileage = mileage;
        this.customerId = customerId;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getLicensePlate() {
        return licensePlate;
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getYearOfManufacture() {
        return yearOfManufacture;
    }

    public void setYearOfManufacture(Integer yearOfManufacture) {
        this.yearOfManufacture = yearOfManufacture;
    }

    public Integer getMileage() {
        return mileage;
    }

    public void setMileage(Integer mileage) {
        this.mileage = mileage;
    }

    public Integer getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Integer customerId) {
        this.customerId = customerId;
    }

    @Override
    public String toString() {
        return "Car{" +
                "id=" + id +
                ", licensePlate='" + licensePlate + '\'' +
                ", brand='" + brand + '\'' +
                ", model='" + model + '\'' +
                ", description='" + description + '\'' +
                ", yearOfManufacture=" + yearOfManufacture +
                ", mileage=" + mileage +
                ", customerId=" + customerId +
                '}';
    }
}

