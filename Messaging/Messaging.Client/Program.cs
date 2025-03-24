using MassTransit;
using Messaging.Contracts;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddOpenApi();

builder.Services.AddMassTransit(x =>
    x.UsingRabbitMq((ctx, cfg) =>
    {
        cfg.Host("rabbitmq", "/", h =>
        {
            h.Username("guest");
            h.Password("guest");
        });
        cfg.ConfigureEndpoints(ctx);
    })
);

var app = builder.Build();

app.MapOpenApi();

app.MapGet("/orders/{size:int}", async (int size,IRequestClient<GetOrders> requestClient) =>
    {
        var orders = await requestClient.GetResponse<GetOrdersResponse>(new GetOrders
        {
            Size = size
        });
        return Results.Ok(orders.Message.Orders);
    })
    .WithName("GetOrders");

app.Run();