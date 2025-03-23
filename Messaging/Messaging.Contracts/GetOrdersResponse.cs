namespace Messaging.Contracts;

public record GetOrdersResponse
{
    public Order[] Orders { get; init; } = [];
}

public record Order
{
    public Guid OrderId { get; init; }
    public DateTime OrderDate { get; init; }
}