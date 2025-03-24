using System.Diagnostics;
using MassTransit;
using Messaging.Contracts;
using Messaging.Worker;

var builder = Host.CreateApplicationBuilder(args);
builder.Services.AddHostedService<Worker>();

builder.Services.AddMassTransit(x =>
{
    x.AddConsumer<GetOrdersConsumer>();
    x.UsingRabbitMq((ctx, cfg) =>
    {
        cfg.Host("rabbitmq", "/", h =>
        {
            h.Username("guest");
            h.Password("guest");
        });
        cfg.ConfigureEndpoints(ctx);
    });
});

var host = builder.Build();
host.Run();

public class GetOrdersConsumer : IConsumer<GetOrders>
{
    public async Task Consume(ConsumeContext<GetOrders> context)
    {
        await Task.Delay(500);
        var orders = Enumerable.Range(1, context.Message.Size).Select(index =>
                new Order
                {
                    OrderId = Guid.NewGuid(),
                    OrderDate = DateTime.Now.AddDays(-index),
                })
            .ToArray();

        await context.RespondAsync(new GetOrdersResponse
        {
            Orders = orders
        });
    }
}