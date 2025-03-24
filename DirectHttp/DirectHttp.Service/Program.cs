
var builder = WebApplication.CreateBuilder(args);
builder.WebHost.ConfigureKestrel(options =>
{
    options.Limits.MaxConcurrentConnections = 100;
});
builder.Services.AddOpenApi();

var app = builder.Build();
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}


app.MapGet("/orders/{size:int}", async (int size) =>
    {
        
        await Task.Delay(500);
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