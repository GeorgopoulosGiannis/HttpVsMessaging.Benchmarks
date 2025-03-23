var builder = WebApplication.CreateBuilder(args);

builder.Services.AddOpenApi();

var app = builder.Build();
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}


app.MapGet("/orders/{size:int}", (int size) =>
    {
        var orders = Enumerable.Range(1, size).Select(index =>
                new Order
                {
                    OrderId = Guid.NewGuid(),
                    OrderDate = DateTime.Now.AddDays(-index),
                })
            .ToArray();
        return orders;
    })
    .WithName("GetOrders");

app.Run();

public record Order
{
    public Guid OrderId { get; init; }
    public DateTime OrderDate { get; init; }
}