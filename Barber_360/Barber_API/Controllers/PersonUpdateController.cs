using Application.Interfaces.PersonUpdate;
using Domain.Entidades.Person;
using Microsoft.AspNetCore.Mvc;

[ApiController]
[Route("api/person/update")]
public class PersonUpdateController : ControllerBase
{
    private readonly IPersonUpdateBLL _service;

    public PersonUpdateController(IPersonUpdateBLL service)
    {
        _service = service;
    }

    [HttpPut]
    public async Task<IActionResult> Update(Person request)
    {
        var result = await _service.UpdateAsync(request);

        if (!result)
            return BadRequest(new
            {
                success = false,
                message = "No se pudo actualizar la persona"
            });

        return Ok(new { success = true });
    }
}
