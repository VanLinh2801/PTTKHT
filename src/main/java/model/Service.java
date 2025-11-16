package model;

public class Service {
    private Integer id;
    private String name;
    private Double price;
    private String description;
    private String estimateDuration;
    private String category;
    private String status;

    public Service() {}

    public Service(String name, Double price, String description, String estimateDuration, 
                   String category, String status) {
        this.name = name;
        this.price = price;
        this.description = description;
        this.estimateDuration = estimateDuration;
        this.category = category;
        this.status = status;
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

    public String getEstimateDuration() {
        return estimateDuration;
    }

    public void setEstimateDuration(String estimateDuration) {
        this.estimateDuration = estimateDuration;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Service{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", price=" + price +
                ", description='" + description + '\'' +
                ", estimateDuration='" + estimateDuration + '\'' +
                ", category='" + category + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}