
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddOpenApi();

builder.Services.AddHttpClient("service-client", client => { client.BaseAddress = new Uri("http://localhost:5175"); });

var app = builder.Build();

app.MapOpenApi();

app.MapGet("/orders/{size:int}", async (int size,IHttpClientFactory clientFactory) =>
    {
        var client = clientFactory.CreateClient("service-client");
        var response = await client.GetFromJsonAsync<Order[]>($"/orders/{size}");

        return Results.Ok(response);
    })
    .WithName("GetOrders");

app.Run();

public record Order
{
    public Guid OrderId { get; init; }
    public DateTime OrderDate { get; init; }
}